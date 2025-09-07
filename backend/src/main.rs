use axum::{
    routing::get,
    Router,
    response::Json,
};
use tower_http::cors::CorsLayer;
use std::net::SocketAddr;

// TODO: 模块暂时注释，待实现具体功能时启用
// mod api;
// mod models;  
// mod services;
// mod db;
// mod utils;

#[tokio::main]
async fn main() {
    // 初始化日志
    tracing_subscriber::fmt::init();
    
    // 构建路由
    let app = Router::new()
        .route("/", get(root))
        .route("/health", get(health_check))
        .layer(CorsLayer::permissive());
    
    // 启动服务器
    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    println!("🚀 YourWallet Backend server starting on http://{}", addr);
    
    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

async fn root() -> Json<serde_json::Value> {
    Json(serde_json::json!({
        "message": "Welcome to YourWallet API",
        "version": "0.1.0"
    }))
}

async fn health_check() -> Json<serde_json::Value> {
    Json(serde_json::json!({
        "status": "healthy",
        "timestamp": chrono::Utc::now()
    }))
}