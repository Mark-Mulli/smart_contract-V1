# pragma version ^0.4.0

"""
@license MIT
@author Mark
@title Buy Me A Coffee!
@notice This contract is for creating a sample funding contract

"""

interface AggregatorV3Interface:
    def decimals() -> uint8: view
    def description() -> String[1000]: view
    def version() -> uint256: view
    def latestAnswer() -> int256: view

MINIMUM_USD: public(constant(uint256)) = as_wei_value(5, "ether")
PRICE_FEED: public(immutable(AggregatorV3Interface))
OWNER: public(address)
PRECISION: constant(uint256) = (1 * (10 ** 18))

funders: public(DynArray[address, 1000])
funder_to_amount_funded: public(HashMap[address, uint256])

@deploy
def __init__(price_feed_address: address):
    PRICE_FEED = AggregatorV3Interface(price_feed_address)
    self.OWNER = msg.sender

@internal
@payable
def _fund():
    """
    Allows users to send money to this contract
    Have a minimum $ amount sent

    """
    usd_value_of_eth: uint256 = self._get_eth_to_usd(msg.value)
    assert usd_value_of_eth >= MINIMUM_USD, "You need to spend more ETH!"
    self.funders.append(msg.sender)
    self.funder_to_amount_funded[msg.sender] += msg.value


@external
@payable
def fund():
    self._fund()
    


@external
def withdraw():
    assert msg.sender == self.OWNER, "Not the contract owner!"
    # send(OWNER, self.balance)
    raw_call(self.OWNER, b"", value = self.balance)

    for funder:address in self.funders:
        self.funder_to_amount_funded[funder] = 0

    self.funders = []  

@external 
@view
def total_funds() -> uint256:
    sum: uint256 = 0
    for funder: address in self.funders:
        sum = sum + self.funder_to_amount_funded[funder]
    return sum

@external 
def change_owner(new_address: address) -> address:
    assert (new_address != self.OWNER), "Cannot change the owner to the same address!"
    self.OWNER = new_address
    return self.OWNER




    

@internal
@view
def _get_eth_to_usd(eth_amount: uint256) -> uint256:

    price: int256 = staticcall PRICE_FEED.latestAnswer() # 271683000000

    eth_price: uint256 = convert(price, uint256) * (10 ** 10)

    eth_amount_in_usd: uint256 = (eth_amount*eth_price) // PRECISION

    return eth_amount_in_usd


@external
@view
def get_eth_to_usd(eth_amount: uint256) -> uint256:
    return self._get_eth_to_usd(eth_amount)


@external
@payable
def __default__():
    self._fund()

# @external
# @view
# def get_price() -> int256:
#    price_feed: AggregatorV3Interface = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
#    return staticcall price_feed.latestAnswer ()
# PRICE FEED ADDRESS = 0xD9d6f482B88C43B256fD481826890dffC8544B13