# pragma version 0.4.0
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

@deploy
def __init__():
    self.minimum_usd = 5

@external
@payable
def fund():
    """
    Allows users to send money to this contract
    Have a minimum $ amount sent
    """
    assert msg.value >= as_wei_value(1, "ether"), "You need to spend more ETH!"

    pass

@external
def withdraw():
    pass

@internal
def _get_eth_to_usd():
    pass

@external
def get_price() -> int256:
   price_feed: AggregatorV3Interface = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
   return price_feed.latestAnswer()