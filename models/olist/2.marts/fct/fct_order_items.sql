with order_items as (
    select *
    from {{ ref('stg_order_items') }}
),

orders as (
    select *
    from {{ ref('stg_orders') }}
),

customers as (
    select *
    from {{ ref('stg_customers') }}
)

select
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,

    o.customer_id,
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,

    o.order_status,
    date(o.order_purchase_ts) as order_date,

    oi.shipping_limit_ts,
    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value as item_gmv,

    case
        when o.order_delivered_customer_date is not null
        then date_diff(date(o.order_delivered_customer_date), date(o.order_purchase_ts), day)
        else null
    end as days_to_deliver,

    case
        when o.order_delivered_customer_date is not null
         and o.order_estimated_delivery_date is not null
        then date_diff(date(o.order_delivered_customer_date), date(o.order_estimated_delivery_date), day)
        else null
    end as delivery_delay_days,

    case
        when o.order_status = 'delivered' then 1
        else 0
    end as is_delivered

from order_items oi
left join orders o
    on oi.order_id = o.order_id
left join customers c
    on o.customer_id = c.customer_id

where o.order_status not in ('canceled', 'unavailable')

