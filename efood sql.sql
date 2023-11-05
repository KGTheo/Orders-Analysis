--Overview
SELECT 
      COUNT(DISTINCT user_id) AS num_users,
      COUNT(DISTINCT order_id) AS num_orders,
      MIN(order_timestamp) AS min_timestamp,
      MAX(order_timestamp) AS max_timestamp,
      COUNT(DISTINCT city) AS total_cities,
      COUNT(DISTINCT vertical) as types_of_verticals,
      COUNT(DISTINCT device) as types_of_devices,
      COUNT(DISTINCT cuisine) as types_of_cuisines,
      SUM(CASE WHEN paid_cash = TRUE THEN 1 ELSE 0  END) AS orders_with_cash,
      SUM(CASE WHEN order_contains_offer= TRUE THEN 1 ELSE 0  END) AS orders_with_offers,
      SUM(coupon_discount_amount) AS total_coupons_discount,
      SUM(amount) AS total_amount
FROM `efood2022-404018.main_assesment.orders`

--Cities Comparison
SELECT city,
      COUNT(DISTINCT user_id) AS num_users,
      COUNT(DISTINCT order_id) AS num_orders,
      SUM(amount) AS total_amount,
      SUM(amount)/COUNT(DISTINCT order_id) AS avg_amount_per_order,
      COUNT(DISTINCT order_id)/COUNT(DISTINCT user_id) AS orders_per_user
FROM `efood2022-404018.main_assesment.orders`
GROUP BY city
ORDER BY total_amount DESC; 

--Cuisines Comparison
WITH CuisineSummary AS (
  SELECT
    cuisine,
    COUNT(order_id) AS order_count,
    AVG(amount) AS avg_order_amount
  FROM `efood2022-404018.main_assesment.orders`
  GROUP BY cuisine
)
SELECT
  *,
  order_count * 100.0 / SUM(order_count) OVER () AS order_count_percent
FROM CuisineSummary;

--Customer Segmentation
SELECT user_class_name,
       COUNT(*) AS num_orders,
       AVG(amount) AS avg_order_amount,
       SUM(amount) as total_amount,
       SUM(coupon_discount_amount) AS total_coupon_discount,
       AVG(delivery_cost) AS avg_delivery_cost
FROM `efood2022-404018.main_assesment.orders`
GROUP BY user_class_name
ORDER BY num_orders DESC;


--Offers Comparison
WITH Offers AS (
  SELECT
    order_contains_offer,
    COUNT(order_id) AS order_count,
  FROM `efood2022-404018.main_assesment.orders`
  GROUP BY order_contains_offer
)
SELECT
  *,
  order_count * 100.0 / SUM(order_count) OVER () AS order_count_percent
FROM Offers;


--Order Distribution by Hour of the Day
SELECT
  EXTRACT(HOUR FROM order_timestamp) AS hour_of_day,
  COUNT(*) AS order_count,
  COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS order_percentage
FROM `efood2022-404018.main_assesment.orders`
GROUP BY hour_of_day
ORDER BY hour_of_day;

--Weekly balance by week
SELECT
    EXTRACT(DAYOFWEEK FROM order_timestamp) AS weekday,
    cuisine,
    COUNT(*) AS num_orders
  FROM `efood2022-404018.main_assesment.orders`
  GROUP BY weekday, cuisine

