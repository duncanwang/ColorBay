pragma solidity ^0.4.21;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

}


contract ERC20
{
    function totalSupply() constant returns (uint256 supply);
    
    function balanceOf(address who) constant returns (uint256 value);
    
    function allowance(address owner, address spender) constant returns (uint256 _allowance);
    
    function transfer(address to, uint256 value) returns (bool ok);
    
    function transferFrom(address from, address to, uint256 value) returns (bool ok);
    
    function approve(address spender, uint256 value) returns (bool ok);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
}

contract BaseContract is ERC20
{
    using SafeMath for uint256; 
    uint256 public totalSupply; 
    mapping(address => uint256) balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

}

contract ColorBayTestToken is BaseContract {
    string public name = "ColorBayBlock";
    string public symbol = "CBT";
    uint public decimals = 18;
    
    function ColorBayTestToken(uint256 initSupply) public {
        totalSupply = initSupply;
        balances[msg.sender] = initSupply;
    }
}
