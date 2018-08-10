pragma solidity ^0.4.23;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
   * @dev Multiplies two numbers, throws on overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
   * @dev Integer division of two numbers, truncating the quotient.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
   * @dev Adds two numbers, throws on overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;

  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
  
}


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpauseunpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender)
    public view returns (uint256);

  function transferFrom(address from, address to, uint256 value)
    public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

}


/**
 * @title Standard ERC20 token
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    returns (bool)
  {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}


/**
 * @title Pausable token
 * @dev StandardToken modified with pausable transfers.
 **/
contract PausableToken is StandardToken, Pausable {

  function transfer(
    address _to,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.transfer(_to, _value);
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(
    address _spender,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.approve(_spender, _value);
  }

  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
}

/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */
contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;


  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(
    address _to,
    uint256 _amount
  )
    onlyOwner
    canMint
    public
    returns (bool)
  {
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner canMint public returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }
}


/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is BasicToken {

  event Burn(address indexed burner, uint256 value);

  /**
   * @dev Burns a specific amount of tokens.
   * @param _value The amount of token to be burned.
   */
  function burn(uint256 _value) public 
  {
    _burn(msg.sender, _value);
  }

  function _burn(address _who, uint256 _value) internal 
  {
    require(_value <= balances[_who]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    balances[_who] = balances[_who].sub(_value);
    totalSupply_ = totalSupply_.sub(_value);
    emit Burn(_who, _value);
    emit Transfer(_who, address(0), _value);
  }
}

/**
 * @title Frozenable Token
 * @dev Illegal address that can be frozened.
 */
contract FrozenableToken is Ownable {
    event UpdatedTokenInformation(string name, string symbol);
    mapping (address => bool) public frozenAccount;
    event FrozenFunds(address indexed to, bool frozen);

    function freezeAccount(address _to, bool freeze) public onlyOwner {
        frozenAccount[_to] = freeze;
        emit FrozenFunds(_to, freeze);
    }
}


/**
 * @title Colorbay Token
 * @dev Global digital painting asset platform token.
 * @author colorbay.org 
 */
contract Colorbay is PausableToken, MintableToken, BurnableToken, FrozenableToken {

    string public name = "Colorbay Token";
    string public symbol = "CLB";
    uint256 public decimals = 4;
    uint256 INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));

    /**
     * @dev Initializes the total release
     */
    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = totalSupply_;
        emit Transfer(address(0), msg.sender, totalSupply_);
    }

    /**
     * @dev transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */
    function transfer(address _to, uint256 _value) public returns (bool)
    {
        require(!frozenAccount[msg.sender]);
        return super.transfer(_to, _value);
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
    {
        require(!frozenAccount[msg.sender]);
        return super.transferFrom(_from, _to, _value);
    }
         
    
    /**
     * @dev Update name and symbol
     * @param _name The token name
     * @param _symbol The symbol name
     */
    function setTokenInformation(string _name, string _symbol) public onlyOwner {
        name = _name;
        symbol = _symbol;
        emit UpdatedTokenInformation(name, symbol);
    } 

}


//-----------------------------------------------------------------------
//-----------------------------------------------------------------------


/**
 * @title MultiSign
 * @dev Allows multiple parties to agree on transactions before execution.
 * @author colorbay.org
 */
contract ColorbayMultiSign {

    using SafeMath for uint256;
    
    uint256 public MAX_OWNER_COUNT = 50;

    event Confirmation(address indexed sender, uint256 indexed transactionId);
    event Revocation(address indexed sender, uint256 indexed transactionId);
    event Submission(uint256 indexed transactionId);
    event Execution(uint256 indexed transactionId); 
    event ExecutionSuccess(uint256 indexed transactionId);
    event ExecutionFailure(uint256 indexed transactionId);
    event OwnerAddition(address indexed owner);
    event OwnerRemoval(address indexed owner);
    event RequirementChange(uint256 required);

    mapping (uint256 => Transaction) public transactions;
    mapping (uint256 => mapping(address => bool)) public confirmations;
    mapping (address => bool) public isOwner;
    address[] public owners;
    uint256 public required;
    uint256 public transactionCount;

    ERC20 public token;

    struct Transaction {
        address destination;
        uint256 value;
        bool executed;
    }

    modifier onlyWallet() {
        require(msg.sender == address(this));
        _;
    }

    modifier ownerNotExists(address owner) {
        require(!isOwner[owner]);
        _;
    }

    modifier ownerExists(address owner) {
        require(isOwner[owner]);
        _;
    }

    modifier transactionExists(uint256 transactionId) {
        require(transactions[transactionId].destination != 0);
        _;
    }

    modifier confirmed(uint256 transactionId, address owner) {
        require(confirmations[transactionId][owner]);
        _;
    }

    modifier notConfirmed(uint256 transactionId, address owner) {
        require(!confirmations[transactionId][owner]);
        _;
    }

    modifier notExecuted(uint256 transactionId) {
        require(!transactions[transactionId].executed);
        _;
    }

    modifier notNull(address _address) {
        require(_address != address(0));
        _;
    }

    modifier validRequirement(uint256 ownerCount, uint256 _required) {
        require(ownerCount > 0 && ownerCount <= MAX_OWNER_COUNT && _required > 0 && _required <= ownerCount);
        _;
    }

    /**
     * @dev Contract constructor sets initial owners and required number of confirmations.
     * @param _owners List of initial owners.
     * @param _required Number of required confirmations.
     */
    constructor(address _token, address[] _owners, uint256 _required) public validRequirement(_owners.length, _required)
    {
        token = ERC20(_token);
        require(_owners.length <= 100);
        for (uint256 i=0; i<_owners.length; i++) {  
            require(!isOwner[_owners[i]] && _owners[i] != address(0));             
            isOwner[_owners[i]] = true;
        }
        owners = _owners;
        required = _required;
    }

    /** 
     * 
     * @dev Allows to add a new owner. Transaction has to be sent by wallet.
     * @param owner Address of new owner.
     */
    function addOwner(address owner) public onlyWallet ownerNotExists(owner) notNull(owner) validRequirement(owners.length.add(1), required)
    {
        isOwner[owner] = true;
        owners.push(owner);
        emit OwnerAddition(owner);
    }

    /** 
     * 
     * @dev Allows to remove an owner. Transaction has to be sent by wallet.
     * @param owner Address of owner.
     */
    function removeOwner(address owner) public onlyWallet ownerExists(owner)
    {
        isOwner[owner] = false;
        for (uint256 i=0; i<owners.length.sub(1); i++) {
            if (owners[i] == owner) {
                owners[i] = owners[owners.length.sub(1)];
                break;
            }
        }            
        owners.length = owners.length.sub(1);
        if (required > owners.length) {
            changeRequirement(owners.length);
        }            
        emit OwnerRemoval(owner);
    }

    /** 
     * 
     * @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
     * @param owner Address of owner to be replaced.
     * @param newOwner Address of new owner.
     */
    function replaceOwner(address owner, address newOwner) public onlyWallet ownerExists(owner) ownerNotExists(newOwner)
    {
        for(uint256 i=0; i<owners.length; i++) {
            if (owners[i] == owner) {
                owners[i] = newOwner;
                break;
            }
        }            
        isOwner[owner] = false;
        isOwner[newOwner] = true;
        emit OwnerRemoval(owner);
        emit OwnerAddition(newOwner);
    }

    /** 
     * 
     * @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
     * @param _required Number of required confirmations.
     */
    function changeRequirement(uint256 _required) public onlyWallet validRequirement(owners.length, _required)
    {
        required = _required;
        emit RequirementChange(_required);
    }

    /** 
     * 
     * @dev Allows an owner to submit and confirm a transaction.
     * @param destination Transaction target address.
     * @param value Transaction ether value.
     * @return Returns transaction ID.
     */
    function submitTransaction(address destination, uint256 value) public returns (uint256 transactionId)
    {
        transactionId = addTransaction(destination, value);
        confirmTransaction(transactionId);
    }

    /** 
     * 
     * @dev Allows an owner to confirm a transaction.
     * @param transactionId Transaction ID.
     */
    function confirmTransaction(uint256 transactionId) public ownerExists(msg.sender) transactionExists(transactionId) notConfirmed(transactionId, msg.sender)
    {
        confirmations[transactionId][msg.sender] = true;
        emit Confirmation(msg.sender, transactionId);
        executeTransaction(transactionId);
    }

    /** 
     * 
     * @dev Allows an owner to revoke a confirmation for a transaction.
     * @param transactionId Transaction ID.
     */
    function revokeConfirmation(uint256 transactionId) public ownerExists(msg.sender) confirmed(transactionId, msg.sender) notExecuted(transactionId)
    {
        confirmations[transactionId][msg.sender] = false;
        emit Revocation(msg.sender, transactionId);
    }

    /** 
     * 
     * @dev Allows anyone to execute a confirmed transaction.
     * @param transactionId Transaction ID.
     */
    function executeTransaction(uint256 transactionId) public notExecuted(transactionId)
    {
        if (isConfirmed(transactionId)) {
            Transaction storage ta = transactions[transactionId];
            ta.executed = true;
            if(token.transfer(ta.destination, ta.value)) {
                emit ExecutionSuccess(transactionId);
            } else {
                emit ExecutionFailure(transactionId);
                ta.executed = false;
            }
        }
    }

    /** 
     * 
     * @dev Returns the confirmation status of a transaction.
     * @param transactionId Transaction ID.
     * @return Confirmation status.
     */
    function isConfirmed(uint256 transactionId) public view returns (bool)
    {
        uint256 count = 0;
        for (uint256 i=0; i<owners.length; i++) {
            if (confirmations[transactionId][owners[i]]) {
                count = count.add(1);
            }                
            if (count == required) {
                return true;
            }                
        }
    }

    /** 
     * 
     * @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
     * @param destination Transaction target address.
     * @param value Transaction ether value.
     * @return Returns transaction ID.
     */
    function addTransaction(address destination, uint256 value) internal notNull(destination) returns (uint256 transactionId)
    {
        transactionId = transactionCount;
        transactions[transactionId] = Transaction({
            destination: destination,
            value: value,
            executed: false
        });
        transactionCount = transactionCount.add(1);
        emit Submission(transactionId);
    }

    /** 
     * 
     * Web3 call functions
     * @dev Returns number of confirmations of a transaction.
     * @param transactionId Transaction ID.
     * @return Number of confirmations.
     */
    function getConfirmationCount(uint256 transactionId) public view returns (uint256 count)
    {
        for (uint256 i=0; i<owners.length; i++) {
            if (confirmations[transactionId][owners[i]]) {
                count = count.add(1);
            }
        }            
                
    }

    /** 
     * 
     * @dev Returns total number of transactions after filers are applied.
     * @param pending Include pending transactions.
     * @param executed Include executed transactions.
     * @return Total number of transactions after filters are applied.
     */
    function getTransactionCount(bool pending, bool executed) public view returns (uint256 count)
    {
        for (uint256 i=0; i<transactionCount; i++) {
            if (pending && !transactions[i].executed || executed && transactions[i].executed) {
                count = count.add(1);
            }
        }           
                
    }

    /** 
     * 
     * @dev Returns list of owners.
     * @return List of owner addresses.
     */
    function getOwners() public view returns (address[])
    {
        return owners;
    }

    /** 
     * 
     * @dev Returns array with owner addresses, which confirmed transaction.
     * @param transactionId Transaction ID.
     * @return Returns array of owner addresses.
     */
    function getConfirmations(uint256 transactionId) public view returns (address[] _confirmations)
    {
        address[] memory confirmationsTemp = new address[](owners.length);
        uint256 count = 0;
        for (uint256 i=0; i<owners.length; i++) {
            if (confirmations[transactionId][owners[i]]) {
                confirmationsTemp[count] = owners[i]; 
                count = count.add(1);
            }
        }            
        _confirmations = new address[](count);
        for (i=0; i<count; i++) {
            _confirmations[i] = confirmationsTemp[i];
        }

    }

    
    /** 
     * 
     * @dev Returns list of transaction IDs in defined range.
     * @param from Index start position of transaction array.
     * @param to Index end position of transaction array.
     * @param pending Include pending transactions.
     * @param executed Include executed transactions.
     * @return Returns array of transaction IDs.
     */
    function getTransactionIds(uint256 from, uint256 to, bool pending, bool executed) public view returns (uint256[] _transactionIds)
    {
        uint256[] memory transactionIdsTemp = new uint256[](transactionCount);
        uint256 count = 0;
        for (uint256 i=0; i<transactionCount; i++) {
            if (pending && !transactions[i].executed || executed && transactions[i].executed)
            {
                transactionIdsTemp[count] = i;
                count = count.add(1);
            }
        }            
        _transactionIds = new uint256[](to.sub(from));
        for (i=from; i<to; i++) {
            _transactionIds[i.sub(from)] = transactionIdsTemp[i];
        }
            
    }

}

