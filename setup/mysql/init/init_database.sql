-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema sandbox
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `sandbox` ;

-- -----------------------------------------------------
-- Schema sandbox
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sandbox` DEFAULT CHARACTER SET utf8 ;
USE `sandbox` ;

-- -----------------------------------------------------
-- Table `sandbox`.`companies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sandbox`.`companies` (
  `company_id` INT NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(45) NULL,
  PRIMARY KEY (`company_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sandbox`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sandbox`.`users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NOT NULL,
  `company_id` INT NOT NULL,
  `is_deleted` INT NULL DEFAULT 0,
  `updated_at` DATETIME NULL,
  `updated_by` VARCHAR(45) NULL,
  `operation` VARCHAR(45) NULL,
  PRIMARY KEY (`user_id`),
  INDEX `fk_users_companies1_idx` (`company_id` ASC) VISIBLE,
  CONSTRAINT `fk_users_companies1`
    FOREIGN KEY (`company_id`)
    REFERENCES `sandbox`.`companies` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sandbox`.`actions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sandbox`.`actions` (
  `action_id` INT NOT NULL AUTO_INCREMENT,
  `action_type` VARCHAR(45) NULL,
  `data` JSON NULL,
  `acted_at` DATETIME NULL,
  `acted_by` VARCHAR(45) NULL,
  PRIMARY KEY (`action_id`))
ENGINE = InnoDB;

USE `sandbox`;

DELIMITER $$
USE `sandbox`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sandbox`.`users_AFTER_INSERT` AFTER INSERT ON `users` FOR EACH ROW
BEGIN
  SET @json = CONCAT(
    "{",
    "\"user_id\":", NEW.user_id, ",",
    "\"user_name\":", "\"", NEW.user_name, "\"", ",",
    "\"company_id\":", "\"", NEW.company_id, "\"",
    "}");
  INSERT INTO `actions` (`action_type`, `data`, `acted_at`, `acted_by`) VALUES (NEW.operation, @json, NEW.updated_at, NEW.updated_by);
END$$

USE `sandbox`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sandbox`.`users_AFTER_UPDATE` AFTER UPDATE ON `users` FOR EACH ROW
BEGIN
  SET @json = CONCAT(
    "{",
    "\"user_id\":", NEW.user_id, ",",
    "\"user_name\":", "\"", NEW.user_name, "\"", ",",
    "\"company_id\":", "\"", NEW.company_id, "\"",
    "}");
  INSERT INTO `actions` (`action_type`, `data`, `acted_at`, `acted_by`) VALUES (NEW.operation, @json, NEW.updated_at, NEW.updated_by);
END$$


DELIMITER ;

-- -----------------------------------------------------
-- Data for table `sandbox`.`companies`
-- -----------------------------------------------------
START TRANSACTION;
USE `sandbox`;
INSERT INTO `sandbox`.`companies` (`company_id`, `company_name`) VALUES (1, '企業名1');

COMMIT;


-- -----------------------------------------------------
-- Data for table `sandbox`.`users`
-- -----------------------------------------------------
START TRANSACTION;
USE `sandbox`;
INSERT INTO `sandbox`.`users` (`user_id`, `user_name`, `company_id`, `is_deleted`, `updated_at`, `updated_by`, `operation`) VALUES (1, 'ユーザ名1', 1, 0, '2018-10-20 12:34:56', 'ユーザ名1', 'createUser');
INSERT INTO `sandbox`.`users` (`user_id`, `user_name`, `company_id`, `is_deleted`, `updated_at`, `updated_by`, `operation`) VALUES (2, 'ユーザ名2', 1, 0, '2018-10-20 12:34:56', 'ユーザ名1', 'createUser');
INSERT INTO `sandbox`.`users` (`user_id`, `user_name`, `company_id`, `is_deleted`, `updated_at`, `updated_by`, `operation`) VALUES (3, 'ユーザ名3', 1, 0, '2018-10-20 12:34:56', 'ユーザ名1', 'createUser');

COMMIT;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
