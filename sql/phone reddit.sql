CREATE TABLE `phone_ch_reddit` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`redgkit` VARCHAR(20) NOT NULL,
	`time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


CREATE TABLE `phone_reddit` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`redgkit` VARCHAR(20) NULL DEFAULT NULL,
	`reditsage` VARCHAR(255) NULL DEFAULT NULL,
	`time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
