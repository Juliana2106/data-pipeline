SELECT
    ID,
    ORDERID as order_id,
    PAYMENTMETHOD,
    STATUS as payment_status,
    AMOUNT as amount,
    CREATED,
    _BATCHED_AT
FROM {{ source('stripe', 'payment') }}
