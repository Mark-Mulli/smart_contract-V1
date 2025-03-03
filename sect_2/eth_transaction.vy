# pragma version ^0.4.0
# @license: MIT
# @author: Mark

#Get funds from users
#Withdraw those funds
#Set a minimum funding value

interface AggregatorV3Interface:
    def decimals() -> uint8: view
    def description() -> String[1000]: view
    def version() -> uint256: view
    def latestAnswer() -> int256: view

minimum_usd: uint256
price_feed: AggregatorV3Interface
owner: public(address)

@deploy
def __init__(price_feed_address: address):
    self.minimum_usd = as_wei_value(5, "ether")
    self.price_feed = AggregatorV3Interface(price_feed_address)
    self.owner = msg.sender

@external
@payable
def fund():
    """
    Allows users to send money to this contract
    Have a minimum $ amount sent
    """

    usd_value_of_eth: uint256 = self._get_eth_to_usd(msg.value)
    assert usd_value_of_eth >= self.minimum_usd, "You need to spend more ETH!"
    


@external
def withdraw():
    assert msg.sender == self.owner, "Not the contract owner!"
    send(self.owner, self.balance)
    

@internal
@view
def _get_eth_to_usd(eth_amount: uint256) -> uint256:

    price: int256 = staticcall self.price_feed.latestAnswer() # 271683000000

    eth_price: uint256 = convert(price, uint256) * (10 ** 10)

    eth_amount_in_usd: uint256 = (eth_amount*eth_price) // (1 * (10 ** 18))

    return eth_amount_in_usd


@external
@view
def get_eth_to_usd(eth_amount: uint256) -> uint256:
    return self._get_eth_to_usd(eth_amount)

# @external
# @view
# def get_price() -> int256:
#    price_feed: AggregatorV3Interface = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
#    return staticcall price_feed.latestAnswer ()
