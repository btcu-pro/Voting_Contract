pragma solidity ^0.4.24;

import "./SafeMath.sol";
import "./Roles.sol";


/// @title Voting 
contract Ballot is SuperAdminRole, CommonRole, CouncilRole {
    using SafeMath for uint256;

    enum Status {
        Begin,
        On,
        Done
    }
    // This is a type for a single proposal.
    struct Proposal {
        uint256 id;         // 提案id
        string path;        // 用于保存链接到提案的网址
        Status status;      // 提案状态
        address proposaler; // 提案提出者地址
        uint256 begin;      // 提案出生时刻
        uint256 on;         // 提案可投票时刻
        uint256 end;        // 投票结束时刻
        uint256 support;    // 支持票数
        uint256 oppose;     // 反对票数
    }
    // A dynamically-sized array of `Proposal` structs.
    Proposal[] public proposals;

  
}