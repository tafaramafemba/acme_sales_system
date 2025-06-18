# 🛒 Acme Widget Co: Sales Basket System

Welcome to the Acme Widget Co Basket System!  
This is a clean, fun, and extensible Ruby implementation of a shopping basket system built for the world’s finest *imaginary* widget company.  

Created as a proof of concept for a technical challenge, this project focuses on core engineering skills—clean architecture, encapsulated logic, testability, and extensibility—with no unnecessary UI fluff.

---

## 👨‍💻 Developed By

**Tafara Mafemba**  
Ruby Developer | Systems Thinker | Builder of things that (mostly) work™  
🇿🇼 Proudly crafted with passion and precision

---

## 🚀 How to Run

Make sure you have Ruby installed (2.7+ or 3.x). Then:

```bash
ruby acme_sales_system.rb
````

You’ll see a set of pre-defined test baskets and their totals printed out to the console.

---

## 🧩 Project Overview

This system was built around good Ruby principles:

* ✅ **Object-oriented design** with separation of concerns
* ✅ **Strategy pattern** for flexible offer logic
* ✅ **Dependency injection** for maximum testability
* ✅ **Readable**, **simple**, and **modular**

---

## 📦 Core Classes

### 🧱 `Product`

Defines a widget with:

* `code` – unique identifier
* `name` – product name
* `price` – base price

---

### 🗂️ `Catalogue`

A mini product lookup system. Given a product code, it returns the corresponding `Product` object. Injected into the `Basket` so we don’t hardcode anything.

---

### 🚚 `DeliveryRule`

Applies delivery fees based on the basket subtotal:

* Under \$50 → \$4.95
* Under \$90 → \$2.95
* \$90 or more → Free delivery (yay!)

This logic is injected into the `Basket` so we can change or test it independently.

---

### 🧠 `Offer` (via Strategy Pattern)

Each offer implements the `apply(items)` method.
We currently support:

#### 🟥 `RedWidgetOffer`

* “Buy one red widget (R01), get the second one half price.”
* This is applied in order, so every second `R01` is discounted.

Adding new offers is as easy as creating a new class that inherits from `Offer` and passing it into the basket.

---

### 🧺 `Basket`

Your shopping cart. It:

* Accepts a `catalogue`, `delivery_rule`, and a list of `offers`
* Has an `add(product_code)` method
* Has a `total` method that:

  * Applies offers
  * Applies delivery rules
  * Returns the final rounded total

```ruby
basket = Basket.new(
  catalogue: catalogue,
  delivery_rule: delivery_rule,
  offers: [RedWidgetOffer.new]
)

basket.add("R01")
puts basket.total
```

---

## 🧪 Example Baskets

| Basket Items                      | Expected Total |
| --------------------------------- | -------------- |
| `B01`, `G01`                      | \$37.85        |
| `R01`, `R01`                      | \$54.37        |
| `R01`, `G01`                      | \$60.85        |
| `B01`, `B01`, `R01`, `R01`, `R01` | \$98.27        |

These are built into the CLI runner for quick validation.

---

## 🤔 Assumptions

* All basket totals are rounded to 2 decimal places
* Invalid product codes raise an error
* Only one type of offer implemented so far
* No tax, no stock control (we’re living in a perfect world here 😄)
* This is a **console-only** system (no Rails/UI)
* Only `active_support` is used to support `index_by`

---

## 🛠️ What’s Next?

You could easily expand this system with:

* RSpec or Minitest tests (coming soon!)
* More complex promotions (buy 3 get 1 free, bundles, etc.)
* Persistent cart or database-backed products
* Taxes, currency formatting, and localization
* API interface or GUI (if needed)

---

## 📜 License

This was built as a technical assignment. You’re welcome to fork it, study it, or build upon it.

---

Thanks for checking it out! May your widgets always be red, green, and blue 🟥🟩🟦
— *Tafara Mafemba*
