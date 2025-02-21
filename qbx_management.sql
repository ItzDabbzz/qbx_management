CREATE TABLE IF NOT EXISTS `player_jobs_activity` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) COLLATE utf8mb4_unicode_ci,
  `job` varchar(255) NOT NULL,
  `last_checkin` int NOT NULL,
  `last_checkout` int NULL DEFAULT NULL,
  FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON DELETE CASCADE,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id` (`id` DESC) USING BTREE,
  INDEX `last_checkout` (`last_checkout` ASC) USING BTREE,
  INDEX `citizenid_job` (`citizenid`, `job`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `management_payroll` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `job` varchar(50) NOT NULL,
    `grade` int(11) NOT NULL,
    `salary` int(11) NOT NULL,
    `last_payment` timestamp NULL DEFAULT NULL,
    `payment_interval` int(11) DEFAULT 60, -- minutes
    PRIMARY KEY (`id`),
    UNIQUE KEY `citizen_job` (`citizenid`, `job`)
);

CREATE TABLE IF NOT EXISTS `management_payroll_history` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) NOT NULL,
    `job` varchar(50) NOT NULL,
    `amount` int(11) NOT NULL,
    `paid_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
);
