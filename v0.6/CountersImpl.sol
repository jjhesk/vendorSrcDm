// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./Counters.sol";

contract CountersImpl {
    using Counters for Counters.Counter;

    Counters.Counter private _counter;

    function current() public view returns (uint256) {
        return _counter.current();
    }

    function increment() public {
        _counter.increment();
    }

    function decrement() public {
        _counter.decrement();
    }
}
