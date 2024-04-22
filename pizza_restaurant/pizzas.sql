create table pizza_restaurant.pizzas
(
    id    int auto_increment
        primary key,
    name  varchar(100)  not null,
    price decimal(7, 2) not null,
    check (`price` > 0)
);

