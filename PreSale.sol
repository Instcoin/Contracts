pragma solidity ^0.4.13;

import "./math/SafeMath.sol";

import "./lifecycle/Pausable.sol";


/**
 * @title PreSale
 * @dev The PreSale contract stores balances investors of pre sale stage.
 */
contract PreSale is Pausable {
    
  event Invest(address, uint);

  using SafeMath for uint;
    
  address public wallet;

  uint public start;
  
  uint public total;
  
  uint16 public period;

  mapping (address => uint) balances;

  mapping (address => bool) invested;
  
  address[] public investors;
  
  modifier saleIsOn() {
    require(now > start && now < start + period * 1 days);
    _;
  }
  
  function totalInvestors() constant returns (uint) {
    return investors.length;
  }
  
  function balanceOf(address investor) constant returns (uint) {
    return balances[investor];
  }
  
  function setStart(uint newStart) onlyOwner {
    start = newStart;
  }
  
  function setPeriod(uint16 newPeriod) onlyOwner {
    period = newPeriod;
  }
  
  function setWallet(address newWallet) onlyOwner {
    require(newWallet != address(0));
    wallet = newWallet;
  }

  function invest() saleIsOn whenNotPaused payable {
    wallet.transfer(msg.value);
    balances[msg.sender] = balances[msg.sender].add(msg.value);
    bool isInvested = invested[msg.sender];
    if(!isInvested) {
        investors.push(msg.sender);    
        invested[msg.sender] = true;
    }
    total = total.add(msg.value);
    Invest(msg.sender, msg.value);
  }

  function() external payable {
    invest();
  }

}
