select
    order_id,
    customer_id,
    customer_unique_id,
    customer_state,
    customer_city,

    order_status,

    date(order_purchase_ts) as order_date,

    item_count,
    items_value,
    freight_value,
    payment_value,
    order_gmv,

    case
        when item_count > 0
        then (items_value + freight_value) / item_count
        else null
    end as avg_item_value,

    days_to_deliver,
    delivery_delay_days,

    is_delivered

from {{ ref('int_orders_enhanced') }}

where order_status not in ('canceled', 'unavailable')