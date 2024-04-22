create table pizza_restaurant.items_ordered
(
    id       int auto_increment
        primary key,
    quantity int not null,
    order_id int not null,
    pizza_id int not null,
    constraint items_ordered_ibfk_1
        foreign key (order_id) references pizza_restaurant.orders (id),
    constraint items_ordered_ibfk_2
        foreign key (pizza_id) references pizza_restaurant.pizzas (id)
);

create index order_id
    on pizza_restaurant.items_ordered (order_id);

create index pizza_id
    on pizza_restaurant.items_ordered (pizza_id);

