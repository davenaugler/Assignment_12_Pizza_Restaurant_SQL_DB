create table pizza_restaurant.customers
(
    id           int auto_increment
        primary key,
    first_name   varchar(100)                        null,
    last_name    varchar(100)                        null,
    phone_number varchar(20)                         null,
    created_at   timestamp default CURRENT_TIMESTAMP null,
    constraint phone_number
        unique (phone_number)
);

