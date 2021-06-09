USE `essentialmode`;

CREATE TABLE `shops1` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`store` varchar(100) NOT NULL,
	`item` varchar(100) NOT NULL,
	`price` int(11) NOT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `shops1` (store, item, price) VALUES
	('Engineshop','bread',30),
	('Engineshop','water',15),
;