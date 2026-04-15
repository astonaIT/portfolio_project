with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

order_items as (
    select
        order_id,
        sum(price) as items_value,
        sum(freight_value) as freight_value,
        count(*) as item_count
    from {{ ref('stg_order_items') }}
    group by 1
),

payments as (
    select
        order_id,
        sum(payment_value) as payment_value
    from {{ ref('stg_order_payments') }}
    group by 1
)

select
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,
    o.order_status,
    o.order_purchase_ts,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    coalesce(oi.item_count, 0) as item_count,
    coalesce(oi.items_value, 0) as items_value,
    coalesce(oi.freight_value, 0) as freight_value,
    coalesce(p.payment_value, 0) as payment_value,

    coalesce(oi.items_value, 0) + coalesce(oi.freight_value, 0) as order_gmv,

    case
        when o.order_approved_at is not null
        then date_diff(date(o.order_approved_at), date(o.order_purchase_ts), day)
        else null
    end as days_to_approve,

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
    end as is_delivered,

    case
        when o.order_status = 'canceled' then 1
        else 0
    end as is_canceled

from orders o
left join customers c
    on o.customer_id = c.customer_id
left join order_items oi
    on o.order_id = oi.order_id
left join payments p
    on o.order_id = p.order_id

