

pragma solidity ^0.6.0;

import "./PaymentSplitter.sol";
import "./SafeERC20.sol";

contract PaymentSplitterErc20 is PaymentSplitter {
    //user -> coin -> amount
    mapping(address => mapping(address => uint256)) private _released_coin;
    //coin address -> amount
    mapping(address => uint256)  private _totalReleased_coin;
    using SafeERC20 for IERC20;

    constructor(address[] memory payees, uint256[] memory shares) public payable PaymentSplitter(payees, shares) {

    }

    event PaymentReleasedErc20(address coin, address to, uint256 amount);

    function releaseCoin(address coin_address, address account) public {
        require(_shares[account] > 0, "PaymentSplitter: account has no shares");
        uint256 balance = IERC20(coin_address).balanceOf(address(this));
        uint256 coinTotalReleased = _totalReleased_coin[coin_address];
        uint256 totalReceived = balance.add(coinTotalReleased);
        uint256 released = _released_coin[account][coin_address];
        uint256 payment = totalReceived.mul(_shares[account]).div(_totalShares).sub(released);

        require(payment != 0, "PaymentSplitter: account is not due payment");

        _released_coin[account][coin_address] = _released_coin[account][coin_address].add(payment);
        _totalReleased_coin[coin_address] = _totalReleased_coin[coin_address].add(payment);

        // account.transfer(payment);
        IERC20(coin_address).safeTransfer(account, payment);
        emit PaymentReleasedErc20(coin_address, account, payment);
    }

    function totalReleasedCoin(address coin_address) public view returns (uint256) {
        return _totalReleased_coin[coin_address];
    }


    function releasedCoin(address coin_address, address account) public view returns (uint256) {
        return _released_coin[account][coin_address];
    }

}
