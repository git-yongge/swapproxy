// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
    function approve(address guy, uint wad) external returns (bool);
}

contract SwapToken is Ownable {

    using SafeMath for uint256;
    using Address for address;

    uint256 public _shellTokenRate;
    IUniswapV2Router02 public immutable swapV2Router;

    mapping(address => bool) private whiteList;

    uint256 private _status = 1;
    modifier nonReentrant() {
        require(_status != 2, "ReentrancyGuard: reentrant call");
        _status = 2;
        _;
        _status = 1;
    }

    constructor(address payable routerAddress) {
        IUniswapV2Router02 _swapv2Router = IUniswapV2Router02(routerAddress);
        swapV2Router = _swapv2Router;
    }

    function swapExactETHForTokens(
        address token0,
        address token1,
        bool isWethPair
    ) external payable nonReentrant() {

        require(whiteList[msg.sender] == true, 'Error: Illegal address call');

        uint256 ethBalance = address(this).balance;
        require(ethBalance >= msg.value, "Error: Contract not received eth");

        uint256 nowToken0Balance;
        IERC20 erc20Token0 = IERC20(token0);
        IERC20 erc20Token1 = IERC20(token1);
        if (isWethPair) {

            uint256 initialToken0Balance = erc20Token0.balanceOf(address(this));
            _swapExactETHForTokens(token0, msg.value);
            nowToken0Balance = erc20Token0.balanceOf(address(this));
            require(nowToken0Balance > initialToken0Balance, "Error: swap failed");
        } else {

            uint256 initialToken1Balance = erc20Token1.balanceOf(address(this));
            _swapExactETHForTokens(token1, msg.value);
            uint256 nowToken1Balance = erc20Token1.balanceOf(address(this));
            require(nowToken1Balance > initialToken1Balance, "Error: swap failed");

            uint256 initialToken0Balance = erc20Token0.balanceOf(address(this));
            _swapExactTokensForTokens(token1, token0, address(this), nowToken1Balance);
            nowToken0Balance = erc20Token0.balanceOf(address(this));
            require(nowToken0Balance > initialToken0Balance, "Error: swap failed");
        }

        uint256 amountIn = nowToken0Balance.div(_shellTokenRate);
        erc20Token0.approve(address(swapV2Router), amountIn);
        _swapExactTokensForETHSupportingFeeOnTransferTokens(msg.sender, token0, amountIn);

        uint256 transferAmount = erc20Token0.balanceOf(address(this));
        erc20Token0.transfer(msg.sender, transferAmount);
    }

    function _swapExactETHForTokens(address token, uint256 ethValue) private {
        address[] memory path = new address[](2);
        path[0] = swapV2Router.WETH();
        path[1] = token;
        IWETH wethToken = IWETH(swapV2Router.WETH());
        wethToken.approve(address(swapV2Router), ethValue);
        swapV2Router.swapExactETHForTokens{value: ethValue}(0, path, address(this), block.timestamp + 360);
    }

    function _swapExactTokensForTokens(address token0, address token1, address to, uint256 amountIn) private {
        address[] memory path = new address[](2);
        path[0] = token0;
        path[1] = token1;
        swapV2Router.swapExactTokensForTokens(amountIn, 0, path, to, block.timestamp + 360);
    }

    function _swapExactTokensForETHSupportingFeeOnTransferTokens(address to, address token, uint256 amountIn) private {
        address[] memory path = new address[](2);
        path[0] = token;
        path[1] = swapV2Router.WETH();
        swapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(amountIn, 0, path, to, block.timestamp + 360);
    }

    function setShellRate(uint256 rate) external onlyOwner() {
        require(rate > 0, "Error: Parameter must be greater than 0");
        _shellTokenRate = rate;
    }

    function setWhiteList(address account, bool status) external onlyOwner() {
        require(account != address(0), "Error: Account address cannot be zero");
        whiteList[account] = status;
    }

    receive() external payable {}
}