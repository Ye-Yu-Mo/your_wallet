use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};
use uuid::Uuid;
use rust_decimal::Decimal;

// 用户模型
#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct User {
    pub id: Uuid,
    pub username: String,
    pub email: String,
    pub display_name: String,
    pub avatar_url: Option<String>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

// 创建用户请求
#[derive(Debug, Deserialize)]
pub struct CreateUserRequest {
    pub username: String,
    pub email: String,
    pub display_name: String,
}

// 账户类型枚举
#[derive(Debug, Serialize, Deserialize, Clone)]
pub enum AccountType {
    Cash,         // 现金
    BankCard,     // 银行卡
    CreditCard,   // 信用卡
    Investment,   // 投资账户
    Crypto,       // 加密货币
}

// 账户模型
#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Account {
    pub id: Uuid,
    pub user_id: Uuid,
    pub name: String,
    pub account_type: AccountType,
    pub currency: String,
    pub balance: Decimal,
    pub is_active: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

// 创建账户请求
#[derive(Debug, Deserialize)]
pub struct CreateAccountRequest {
    pub name: String,
    pub account_type: AccountType,
    pub currency: String,
    pub initial_balance: Option<Decimal>,
}

// 交易类型枚举
#[derive(Debug, Serialize, Deserialize, Clone)]
pub enum TransactionType {
    Income,    // 收入
    Expense,   // 支出
    Transfer,  // 转账
    Investment, // 投资
}

// 交易分类
#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Category {
    pub id: Uuid,
    pub name: String,
    pub icon: String,
    pub color: String,
    pub transaction_type: TransactionType,
    pub is_system: bool,
}

// 交易记录模型
#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Transaction {
    pub id: Uuid,
    pub user_id: Uuid,
    pub account_id: Uuid,
    pub category_id: Option<Uuid>,
    pub transaction_type: TransactionType,
    pub amount: Decimal,
    pub currency: String,
    pub description: String,
    pub notes: Option<String>,
    pub tags: Vec<String>,
    pub transaction_date: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

// 创建交易请求
#[derive(Debug, Deserialize)]
pub struct CreateTransactionRequest {
    pub account_id: Uuid,
    pub category_id: Option<Uuid>,
    pub transaction_type: TransactionType,
    pub amount: Decimal,
    pub description: String,
    pub notes: Option<String>,
    pub tags: Option<Vec<String>>,
    pub transaction_date: Option<DateTime<Utc>>,
}

// 更新交易请求
#[derive(Debug, Deserialize)]
pub struct UpdateTransactionRequest {
    pub account_id: Option<Uuid>,
    pub category_id: Option<Uuid>,
    pub amount: Option<Decimal>,
    pub description: Option<String>,
    pub notes: Option<String>,
    pub tags: Option<Vec<String>>,
    pub transaction_date: Option<DateTime<Utc>>,
}

// API响应包装器
#[derive(Debug, Serialize)]
pub struct ApiResponse<T> {
    pub success: bool,
    pub data: Option<T>,
    pub message: String,
    pub timestamp: DateTime<Utc>,
}

impl<T> ApiResponse<T> {
    pub fn success(data: T) -> Self {
        Self {
            success: true,
            data: Some(data),
            message: "Success".to_string(),
            timestamp: Utc::now(),
        }
    }

    pub fn error(message: String) -> Self {
        Self {
            success: false,
            data: None,
            message,
            timestamp: Utc::now(),
        }
    }
}

// 分页查询参数
#[derive(Debug, Deserialize)]
pub struct PaginationQuery {
    pub page: Option<u64>,
    pub limit: Option<u64>,
}

impl Default for PaginationQuery {
    fn default() -> Self {
        Self {
            page: Some(1),
            limit: Some(20),
        }
    }
}

// 分页响应
#[derive(Debug, Serialize)]
pub struct PaginatedResponse<T> {
    pub data: Vec<T>,
    pub page: u64,
    pub limit: u64,
    pub total: u64,
    pub has_next: bool,
}

// 统计数据
#[derive(Debug, Serialize)]
pub struct FinancialSummary {
    pub total_income: Decimal,
    pub total_expense: Decimal,
    pub net_income: Decimal,
    pub account_balances: Vec<AccountBalance>,
}

#[derive(Debug, Serialize)]
pub struct AccountBalance {
    pub account_id: Uuid,
    pub account_name: String,
    pub balance: Decimal,
    pub currency: String,
}