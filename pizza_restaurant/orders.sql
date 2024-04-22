create table pizza_restaurant.orders
(
    id           int auto_increment
        primary key,
    order_placed timestamp default CURRENT_TIMESTAMP null,
    customer_id  int                                 not null,
    constraint orders_ibfk_1
        foreign key (customer_id) references pizza_restaurant.customers (id)
);

create index customer_id
    on pizza_restaurant.orders (customer_id);

