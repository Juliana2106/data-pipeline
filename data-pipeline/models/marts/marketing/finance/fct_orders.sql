with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

-- agregas la medida al mismo grano de la fact table
order_payments as (
    select
        order_id,
        sum(case when payment_status = 'success' then amount end) as amount
    from payments
    group by 1
),

-- unes el grano base con sus medidas y sus llaves a dimensiones
final as (
    select
        orders.order_id,           -- clave primaria (grano)
        orders.customer_id,        -- foreign key hacia dim_customers
        orders.order_date,         -- opcional: útil para filtrar por fecha
        coalesce(order_payments.amount, 0) as amount   -- medida
    from orders
    left join order_payments using (order_id)
)

select * from final
