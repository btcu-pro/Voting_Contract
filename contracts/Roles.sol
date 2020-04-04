pragma solidity 0.4.24;

import "./SafeMath.sol";

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 * @dev more info: https://github.com/OpenZeppelin/openzeppelin-contracts/tree/release-v2.3.0/contracts/access
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

/**
 * @title SuperAdminRole
 * @dev SuperAdmins are responsible for assigning and removing other Role accounts.
 */
contract SuperAdminRole {
    using Roles for Roles.Role;
    using SafeMath for uint256;

    event SuperAdminAdded(address indexed account);
    event SuperAdminRemoved(address indexed account);

    Roles.Role private _SuperAdmins;
    address[] public superAdminAddress;

    constructor () public {
        _addSuperAdmin(msg.sender);
    }

    modifier onlySuperAdmin() {
        require(isSuperAdmin(msg.sender), "SuperAdminRole: caller does not have the SuperAdmin role");
        _;
    }

    /**
     * @dev isSuperAdmin check if the account is super admin
     * @param account the address that will be checked
     * @return bool, true if account is super admin.
     */
    function isSuperAdmin(address account) public view returns (bool) {
        return _SuperAdmins.has(account);
    }

    /**
     * @dev superAdminAmount get the amount of super admin
     * @return the amount of super admin
     */
    function superAdminAmount() public view returns (uint256) {
        return superAdminAddress.length;
    }

    /**
     * @dev addSuperAdmin add another address to super admin
     * @param account the address that will be added
     * @notice only super admin can execute this function
     */
    function addSuperAdmin(address account) public onlySuperAdmin {
        _addSuperAdmin(account);
    }

    /**
     * @dev renounceSuperAdmin remove himself super admin
     * @notice only super admin can execute this function
     * @notice this function can be executed only when superAdminAmount bigger than 1
     */
    function renounceSuperAdmin() public {
        require(superAdminAmount() > 1, "SuperAdmins should more than 0");
        _removeSuperAdmin(msg.sender);
    }

    function _addSuperAdmin(address account) internal {
        _SuperAdmins.add(account);
        superAdminAddress.push(account);

        emit SuperAdminAdded(account);
    }

    function _removeSuperAdmin(address account) internal {
        require(_SuperAdmins.has(account), "Roles: account does not have role");

        _SuperAdmins.remove(account);

        uint256 _i = 0;
        while (superAdminAddress[_i] != account) {
            _i++;
        }
        uint256 _length = superAdminAddress.length;
        superAdminAddress[_i] = superAdminAddress[_length-1];
        superAdminAddress.length = superAdminAddress.length.sub(1);

        emit SuperAdminRemoved(account);
    }
}


/**
 * @title CouncilRole
 * @dev Council accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Councils themselves.
 */
contract CouncilRole is SuperAdminRole {
    using Roles for Roles.Role;

    event CouncilAdded(address indexed account);
    event CouncilRemoved(address indexed account);

    Roles.Role private _Councils;
    address[] public CouncilAddress;

    modifier onlyCouncil() {
        require(isCouncil(msg.sender), "CouncilRole: caller does not have the Council role");
        _;
    }

    /**
     * @dev isCouncil check if the account is in white list
     * @param account the address that will be checked
     * @return bool, return true if account is in white list
     */
    function isCouncil(address account) public view returns (bool) {
        return _Councils.has(account);
    }

    /**
     * @dev CouncilAmount get the amount of white list
     * @return the amount of white list
     */
    function CouncilAmount() public view returns (uint256) {
        return CouncilAddress.length;
    }

    /**
     * @dev addCouncil add another address to white list
     * @param account the address that will be added
     * @notice only super admin can execute this function
     */
    function addCouncil(address account) public onlySuperAdmin {
        _addCouncil(account);
    }

    /**
     * @dev removeCouncil remove someone from white list
     * @param account the address that whill be remove
     * @notice only super admin can execute this function
     */
    function removeCouncil(address account) public onlySuperAdmin {
        _removeCouncil(account);
    }

    function _addCouncil(address account) internal {
        _Councils.add(account);
        CouncilAddress.push(account);

        emit CouncilAdded(account);
    }

    function _removeCouncil(address account) internal {
        require(_Councils.has(account), "Roles: account does not have role");

        _Councils.remove(account);

        uint256 _i = 0;
        while (CouncilAddress[_i] != account) {
            _i++;
        }
        uint256 _length = CouncilAddress.length;
        CouncilAddress[_i] = CouncilAddress[_length-1];
        CouncilAddress.length = CouncilAddress.length.sub(1);

        emit CouncilRemoved(account);
    }
}

/**
 * @title Common Role
 * @dev Common accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Commons themselves.
 */
contract CommonRole is SuperAdminRole {
    using Roles for Roles.Role;

    event CommonAdded(address indexed account);
    event CommonRemoved(address indexed account);

    Roles.Role private _Commons;
    address[] public CommonAddress;

    modifier onlyCommon() {
        require(isCommon(msg.sender), "CommonRole: caller does not have the Common role");
        _;
    }

    /**
     * @dev isCommon check if the account is in white list
     * @param account the address that will be checked
     * @return bool, return true if account is in white list
     */
    function isCommon(address account) public view returns (bool) {
        return _Commons.has(account);
    }

    /**
     * @dev CommonAmount get the amount of white list
     * @return the amount of white list
     */
    function CommonAmount() public view returns (uint256) {
        return CommonAddress.length;
    }

    /**
     * @dev addCommon add another address to white list
     * @param account the address that will be added
     * @notice only super admin can execute this function
     */
    function addCommon(address account) public onlySuperAdmin {
        _addCommon(account);
    }

    /**
     * @dev removeCommon remove someone from white list
     * @param account the address that whill be remove
     * @notice only super admin can execute this function
     */
    function removeCommon(address account) public onlySuperAdmin {
        _removeCommon(account);
    }

    function _addCommon(address account) internal {
        _Commons.add(account);
        CommonAddress.push(account);

        emit CommonAdded(account);
    }

    function _removeCommon(address account) internal {
        require(_Commons.has(account), "Roles: account does not have role");
        _Commons.remove(account);

        uint256 _i = 0;
        while (CommonAddress[_i] != account) {
            _i++;
        }
        uint256 _length = CommonAddress.length;
        CommonAddress[_i] = CommonAddress[_length-1];
        CommonAddress.length = CommonAddress.length.sub(1);

        emit CommonRemoved(account);
    }
}
