## README

**Overview**

This E-commerce platform provides a robust solution for managing products, orders, and dynamic pricing. The system supports the following functionalities:

**Product Import**
Easily import products from a CSV file containing essential details such as name, category, quantity, and default price.

**Product Details**
View detailed information about products, including their dynamic pricing.

**Dynamic Pricing Engine**
Adjusts product prices based on:

- **Demand**: Increases prices for frequently added or purchased products.
- **Inventory Levels**: Decreases prices when inventory is high and increases them when inventory is low.
- **Competitor Prices**: Adjusts prices based on competitor prices fetched from an external API.

**Dynamic Pricing Overview**

The dynamic pricing engine ensures that product prices are competitive and aligned with market demands. It employs various strategies to adjust prices effectively:

- **Demand**: Monitors product additions to carts and purchase frequencies to adjust prices accordingly.
  
- **Inventory Levels**: Reacts to inventory changes to maintain a balanced pricing strategy.
  
- **Competitor Prices**: Fetches competitor pricing data from the external service Pricing API to inform price adjustments.

**API Endpoints**

1. **Import Products**
   - **Endpoint**: POST /products/import
   - **Request Format**:
     ```http
     POST /api/products/import
     Content-Type: multipart/form-data

     {
       "file": <CSV File>
     }
     ```
   - **Response Format**:
     ```json
     {
       "message": "Products will be imported soon."
     }
     ```
   - **Example Usage**:
     ```bash
     curl -X POST -F "file=@path/to/products.csv" http://localhost:3000/products/import
     ```

2. **Show Products Details**
   - **Endpoint**: GET /products
   - **Request Format**:
     ```http
     GET /products
     ```
   - **Response Format**:
     ```json
     {
       "id": "<product_id>",
       "name": "Test Product",
       "category": "Electronics",
       "qty": 50,
       "default_price": 999.99
     }
     ```
   - **Example Usage**:
     ```bash
     curl http://localhost:3000/products
     ```

3. **Place an Order**
   - **Endpoint**: PATCH /orders/:id
   - **Request Format**:
     ```http
     POST /orders/:id
     Content-Type: application/json

     {
       "id": "<order_id>",
       "state": "placed"
     }
     ```
   - **Response Format**:
     ```json
     {
       "message": "Order is now placed.",
       "order_id": "<order_id>"
     }
     ```
   - **Example Usage**:
     ```bash
     curl -X POST -H "Content-Type: application/json" -d '{
       "id": "<order_id>",
       "state": "placed"
     }' http://localhost:3000/orders/:id
     ```

**Postman collection**
Json file Dynamic Pricing.postman_collection.json is the file for the postman collection to have a look of the api's

**Setting Up and Running the Application Locally**

**Prerequisites**
- Ruby (version 3.0 or higher)
- Rails (version 6.0 or higher)
- MongoDB
- Bundler

**Step 1: Clone the Repository**
```bash
git clone https://github.com/Gyan1985/dynamic_pricing.git
cd dynamic_pricing
