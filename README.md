# 🛒 Go gRPC GraphQL Microservices

A production-style **microservices-based e-commerce backend** built with **Go**, **gRPC**, **GraphQL**, **PostgreSQL**, **Elasticsearch**, and **Docker Compose**.

The project demonstrates how independently running services can communicate through **gRPC**, while a **GraphQL API Gateway** provides clients with a single, flexible API.

The system contains three core domain services:

- 👤 Account Service
- 📦 Catalog Service
- 🛍️ Order Service

All services communicate internally using **gRPC**, while clients interact with the system through **GraphQL**.

---

## 🏗️ Architecture

```text
                         ┌─────────────────────┐
                         │       Client        │
                         │  GraphQL Playground │
                         └──────────┬──────────┘
                                    │
                                    │ GraphQL
                                    ▼
                         ┌─────────────────────┐
                         │   GraphQL Gateway   │
                         │      :8000          │
                         └──────────┬──────────┘
                                    │
                         ┌──────────┼──────────┐
                         │          │          │
                       gRPC       gRPC       gRPC
                         │          │          │
                         ▼          ▼          ▼
                  ┌──────────┐ ┌──────────┐ ┌──────────┐
                  │ Account  │ │ Catalog  │ │  Order   │
                  │ Service  │ │ Service  │ │ Service  │
                  │  :8080   │ │  :8080   │ │  :8080   │
                  └────┬─────┘ └────┬─────┘ └────┬─────┘
                       │             │             │
                       ▼             ▼             ▼
                  PostgreSQL    Elasticsearch   PostgreSQL
```

### Service Communication

```text
                    GraphQL
                       │
                       ▼
                ┌─────────────┐
                │   GraphQL   │
                │   Gateway   │
                └──────┬──────┘
                       │
              ┌────────┼────────┐
              │        │        │
             gRPC     gRPC     gRPC
              │        │        │
              ▼        ▼        ▼
          Account   Catalog    Order
              │        │        │
              ▼        ▼        ▼
          PostgreSQL   ES    PostgreSQL
                         │
                         │
                    Product Search
```

---

## ✨ Features

### 👤 Account Management

- Create accounts
- Retrieve an account by ID
- Retrieve multiple accounts
- Pagination support

### 📦 Product Catalog

- Create products
- Retrieve products
- Search products using Elasticsearch
- Filter products by IDs
- Pagination support

### 🛍️ Order Processing

- Create orders for accounts
- Validate accounts before creating orders
- Validate requested products
- Calculate order totals
- Retrieve orders for an account
- Resolve product information through the Catalog Service

### 🔌 Communication

- gRPC for internal service-to-service communication
- GraphQL for client-facing API
- Protocol Buffers for service contracts
- gRPC reflection enabled for development and debugging

### 🐳 Infrastructure

- Dockerized services
- Docker Compose orchestration
- PostgreSQL for transactional data
- Elasticsearch for product search
- Environment-based configuration

---

# 🧰 Tech Stack

| Technology | Purpose |
|------------|---------|
| Go | Backend services |
| gRPC | Inter-service communication |
| Protocol Buffers | Service contracts |
| GraphQL | API Gateway |
| gqlgen | GraphQL implementation |
| PostgreSQL | Account and order persistence |
| Elasticsearch | Product catalog and search |
| Docker | Containerization |
| Docker Compose | Local orchestration |

---

# 📁 Project Structure

```text
go-grpc-graphql-micro/
│
├── account/
│   ├── cmd/
│   │   └── account/
│   ├── pb/
│   ├── repository.go
│   ├── service.go
│   ├── server.go
│   └── client.go
│
├── catalog/
│   ├── cmd/
│   │   └── catalog/
│   ├── pb/
│   ├── repository.go
│   ├── service.go
│   ├── server.go
│   └── client.go
│
├── order/
│   ├── cmd/
│   │   └── order/
│   ├── pb/
│   ├── repository.go
│   ├── service.go
│   ├── server.go
│   └── client.go
│
├── graphql/
│   ├── cmd/
│   │   └── graphql/
│   ├── graph/
│   └── server.go
│
├── docker-compose.yaml
├── go.mod
├── go.sum
└── README.md
```

---

# 🔄 Request Flow

## Creating an Order

Creating an order demonstrates the interaction between multiple microservices.

```text
Client
  │
  │ GraphQL Mutation
  ▼
GraphQL Gateway
  │
  │ gRPC
  ▼
Order Service
  │
  ├───────────────► Account Service
  │                  │
  │                  └── Verify account
  │
  ├───────────────► Catalog Service
  │                  │
  │                  └── Fetch products
  │
  ▼
Order Service
  │
  ├── Calculate total
  ├── Store order
  └── Return order
```

This keeps domain responsibilities separated between services.

---

# 🚀 Getting Started

## Prerequisites

Make sure you have:

- Go
- Docker
- Docker Compose
- Git

Verify your installation:

```bash
go version
docker --version
docker compose version
```

---

# 📥 Clone the Repository

```bash
git clone <repository-url>
cd go-grpc-graphql-micro
```

---

# 🐳 Start the Application

Build and start all services:

```bash
docker compose up -d --build
```

Check running containers:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f
```

View logs for an individual service:

```bash
docker compose logs -f account
docker compose logs -f catalog
docker compose logs -f order
docker compose logs -f graphql
```

---

# 🎮 GraphQL Playground

Once the containers are running, open:

```text
http://localhost:8000/playground
```

The GraphQL endpoint is:

```text
http://localhost:8000/graphql
```

---

# 🔍 GraphQL API

## 👤 Query Accounts

```graphql
query {
  accounts {
    id
    name
  }
}
```

---

## 👤 Get a Specific Account

```graphql
query {
  accounts(id: "account_id") {
    id
    name
  }
}
```

---

## ➕ Create an Account

```graphql
mutation {
  createAccount(account: {name: "New Account"}) {
    id
    name
  }
}
```

---

# 📦 Products

## Query Products

```graphql
query {
  products {
    id
    name
    description
    price
  }
}
```

---

## Create a Product

```graphql
mutation {
  createProduct(
    product: {
      name: "New Product"
      description: "A new product"
      price: 19.99
    }
  ) {
    id
    name
    description
    price
  }
}
```

---

# 🔎 Search Products

The Catalog Service uses Elasticsearch for product search.

```graphql
query {
  products(
    pagination: {
      skip: 0
      take: 5
    }
    query: "laptop"
  ) {
    id
    name
    description
    price
  }
}
```

---

# 📄 Pagination

Products can be paginated using `skip` and `take`.

```graphql
query {
  products(
    pagination: {
      skip: 0
      take: 10
    }
  ) {
    id
    name
    price
  }
}
```

---

# 🛍️ Orders

## Create an Order

```graphql
mutation {
  createOrder(
    order: {
      accountId: "account_id"
      products: [
        {
          id: "product_id"
          quantity: 2
        }
      ]
    }
  ) {
    id
    totalPrice
    products {
      name
      quantity
      price
    }
  }
}
```

When an order is created, the Order Service:

1. Validates the account through the Account Service.
2. Retrieves the requested products from the Catalog Service.
3. Calculates the total price.
4. Persists the order in PostgreSQL.
5. Returns the completed order through GraphQL.

---

# 📋 Get Account Orders

```graphql
query {
  accounts(id: "account_id") {
    name
    orders {
      id
      createdAt
      totalPrice
      products {
        name
        quantity
        price
      }
    }
  }
}
```

---

# 💰 Calculate Total Spent

Order totals can be retrieved through the account's orders:

```graphql
query {
  accounts(id: "account_id") {
    name
    orders {
      totalPrice
    }
  }
}
```

---

# 🔌 gRPC Services

Each domain service exposes a gRPC API.

## Account Service

```text
pb.AccountService
```

Available operations:

```text
PostAccount
GetAccount
GetAccounts
```

## Catalog Service

```text
pb.CatalogService
```

Provides product creation, retrieval, listing, and search operations.

## Order Service

```text
pb.OrderService
```

Provides:

```text
PostOrder
GetOrdersForAccount
```

---

# 🧬 Protocol Buffers

The `.proto` files define the contracts between services.

Example:

```protobuf
service AccountService {
    rpc PostAccount (PostAccountRequest)
        returns (PostAccountResponse);

    rpc GetAccount (GetAccountRequest)
        returns (GetAccountResponse);

    rpc GetAccounts (GetAccountsRequest)
        returns (GetAccountsResponse);
}
```

The generated Go code is used by both gRPC servers and clients.

---

# ⚙️ Generate gRPC Code

## 1. Install Protocol Buffers

Download `protoc`:

```bash
wget https://github.com/protocolbuffers/protobuf/releases/download/v23.0/protoc-23.0-linux-x86_64.zip
```

Extract it:

```bash
unzip protoc-23.0-linux-x86_64.zip -d protoc
```

Move the compiler:

```bash
sudo mv protoc/bin/protoc /usr/local/bin/
```

Verify:

```bash
protoc --version
```

---

## 2. Install Go Plugins

Install the Protocol Buffers Go plugin:

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
```

Install the gRPC Go plugin:

```bash
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```

Add Go binaries to your PATH:

```bash
export PATH="$PATH:$(go env GOPATH)/bin"
```

To make it permanent:

```bash
echo 'export PATH="$PATH:$(go env GOPATH)/bin"' >> ~/.bashrc
source ~/.bashrc
```

Verify:

```bash
protoc-gen-go --version
protoc-gen-go-grpc --version
```

---

## 3. Generate Go gRPC Code

Create a `pb` directory inside the service:

```bash
mkdir -p account/pb
```

Example `account.proto`:

```protobuf
syntax = "proto3";

package pb;

option go_package = "github.com/ritesh-karankal/go-grpc-graphql-micro/account/pb";
```

Generate the Go files:

```bash
protoc \
  --go_out=./account/pb \
  --go-grpc_out=./account/pb \
  account/account.proto
```

This generates:

```text
account/pb/
├── account.pb.go
└── account_grpc.pb.go
```

Repeat the process for the Catalog and Order services.

> Keep the `go_package` option aligned with the Go module path. Avoid using `option go_package = "./pb";` when the generated packages are imported using the full module path.

---

# 🗄️ Databases

## Account Service

Uses PostgreSQL to store account information.

```text
Account Service
      │
      ▼
 PostgreSQL
```

## Order Service

Uses PostgreSQL for transactional order data.

```text
Order Service
      │
      ▼
 PostgreSQL
```

## Catalog Service

Uses Elasticsearch for product storage and search.

```text
Catalog Service
      │
      ▼
 Elasticsearch
```

Elasticsearch enables product search using queries across fields such as:

```text
name
description
```

---

# 🔐 Configuration

Service configuration is provided through environment variables.

Example:

```env
DATABASE_URL=postgres://<user>:<password>@account_db:5432/<database>?sslmode=disable

ACCOUNT_SERVICE_URL=account:8080
CATALOG_SERVICE_URL=catalog:8080
ORDER_SERVICE_URL=order:8080
```

**Do not commit real credentials to Git.**

For local development, use an `.env` file and add it to `.gitignore`.

---

# 🐳 Docker Services

Docker Compose runs the complete application stack:

```text
┌─────────────────────────────┐
│       Docker Compose        │
│                             │
│  ┌─────────┐  ┌─────────┐  │
│  │ Account │  │ Catalog │  │
│  │ Service │  │ Service │  │
│  └────┬────┘  └────┬────┘  │
│       │             │       │
│       ▼             ▼       │
│   PostgreSQL    Elasticsearch
│                             │
│  ┌─────────┐  ┌──────────┐ │
│  │  Order  │  │ GraphQL  │ │
│  │ Service │  │ Gateway  │ │
│  └────┬────┘  └────┬─────┘ │
│       │             │       │
│       ▼             │       │
│   PostgreSQL        │       │
│                     │       │
└─────────────────────┼───────┘
                      │
                      ▼
                 localhost:8000
```

---

# 🧪 Useful Docker Commands

Start:

```bash
docker compose up -d
```

Build and start:

```bash
docker compose up -d --build
```

Stop:

```bash
docker compose down
```

Stop and remove volumes:

```bash
docker compose down -v
```

View services:

```bash
docker compose ps
```

Follow all logs:

```bash
docker compose logs -f
```

Follow a specific service:

```bash
docker compose logs -f order
```

Rebuild one service:

```bash
docker compose build --no-cache account
```

Restart one service:

```bash
docker compose restart account
```

---

# 🔍 Debugging

## Check Service DNS

Docker Compose provides service-name based DNS.

For example:

```bash
docker compose exec graphql getent hosts account
```

Expected output:

```text
172.x.x.x account
```

---

## Check Elasticsearch

From the Catalog container:

```bash
docker compose exec catalog wget -qO- http://catalog_db:9200
```

Check indices:

```bash
docker compose exec catalog \
  wget -qO- http://catalog_db:9200/_cat/indices?v
```

---

## Check gRPC Reflection

The gRPC services have reflection enabled:

```go
reflection.Register(serv)
```

This makes it easier to inspect and debug services during development.

---

# 🧠 Architecture Decisions

## Why gRPC?

gRPC provides:

- Strongly typed service contracts
- Protocol Buffers
- Efficient binary communication
- Generated client/server code
- Excellent support for Go
- Clear service boundaries

---

## Why GraphQL?

GraphQL provides clients with:

- A single API endpoint
- Flexible queries
- Strongly typed schemas
- Ability to request only required fields
- A clean API over multiple microservices

Instead of clients communicating with three different services:

```text
Client → Account
Client → Catalog
Client → Order
```

they communicate with one API:

```text
Client
   │
   ▼
GraphQL Gateway
   │
   ├── Account
   ├── Catalog
   └── Order
```

---

## Why PostgreSQL?

PostgreSQL is used for data that requires reliable transactional persistence.

Examples:

- Accounts
- Orders
- Order products

---

## Why Elasticsearch?

The Catalog Service uses Elasticsearch because product catalogs benefit from:

- Full-text search
- Fast filtering
- Search across multiple fields
- Scalable indexing

---

# 📈 Future Improvements

Potential improvements for this project include:

- [ ] Kubernetes deployment
- [ ] Terraform infrastructure
- [ ] CI/CD with GitHub Actions
- [ ] Prometheus metrics
- [ ] Grafana dashboards
- [ ] Distributed tracing with OpenTelemetry
- [ ] Centralized logging
- [ ] API authentication and authorization
- [ ] JWT authentication
- [ ] gRPC health checks
- [ ] Automated integration tests
- [ ] Unit test coverage
- [ ] Rate limiting
- [ ] Message broker integration
- [ ] Service retries and circuit breakers
- [ ] Kubernetes service discovery
- [ ] Production secrets management

---

# 🎯 What This Project Demonstrates

This project demonstrates practical experience with:

```text
Go
 │
 ├── Microservices
 ├── gRPC
 ├── Protocol Buffers
 ├── GraphQL
 ├── PostgreSQL
 ├── Elasticsearch
 ├── Docker
 └── Distributed service communication
```

The main architectural concepts demonstrated are:

- Service decomposition
- Domain-based microservices
- Synchronous service-to-service communication
- API Gateway pattern
- Database-per-service pattern
- Strongly typed APIs
- Containerized development
- Service discovery through Docker Compose
- Search-oriented data storage
- GraphQL aggregation over multiple microservices

---

# 🧑‍💻 

Built as a hands-on project for learning and demonstrating **Go backend development, gRPC, GraphQL, microservices, databases, and containerized application architecture**.

---

# ⭐ If You Find This Project Useful

If this project helped you understand Go microservices, gRPC, GraphQL, or Docker, consider giving the repository a ⭐.
