CREATE DATABASE TheUnifyProject;
use TheUnifyProject; 

CREATE TABLE `otp_sms` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
  `mobile` varchar( 15 ) NOT NULL,
  `code` varchar( 6 ) NOT NULL,
  `attempt` INT( 3 ) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;


CREATE TABLE `users` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`isActive` INT( 1 ) NOT NULL DEFAULT '0',
`sessionId` VARCHAR( 16 ) NOT NULL ,
`username` VARCHAR( 16 ) NOT NULL ,
`fullname` VARCHAR( 50 ) NOT NULL ,
`mobile` VARCHAR( 14 ) NOT NULL ,
`encrypted_password` VARCHAR( 80 ) NOT NULL,
`salt` VARCHAR( 10 ) NOT NULL,
`gcmToken` VARCHAR( 50 ) NOT NULL ,
`location` VARCHAR( 50 ) NOT NULL ,
`course` VARCHAR( 50 ) NOT NULL ,
`level` VARCHAR( 6 ) NOT NULL ,
`privacy` INT( 1 ) NOT NULL DEFAULT '0',
`isVerify` ENUM( 'false', 'true' ) NOT NULL,
`hasStore` ENUM( 'false', 'true' ) NOT NULL,
`storeName` VARCHAR( 50 ) NOT NULL ,
`storeDescription` VARCHAR( 300 ) NOT NULL ,
`storeDate` timestamp NOT NULL ,
`isSuspend` INT( 1 ) NOT NULL DEFAULT '0',
`created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;


CREATE TABLE `follow` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`username` VARCHAR( 16 ) NOT NULL ,
`target_username` VARCHAR( 16 ) NOT NULL 
)  ENGINE=InnoDB  DEFAULT CHARSET=latin1;


CREATE TABLE `feeds` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`username` VARCHAR( 16 ) NOT NULL ,
`feedMsg` TEXT NOT NULL ,
`feedImg` VARCHAR( 32 ) NOT NULL,
`stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `likes` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`feedId`  INT NOT NULL ,
`username` VARCHAR( 16 ) NOT NULL 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `comments` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`feedId`  INT NOT NULL ,
`username` VARCHAR( 16 ) NOT NULL ,
`comment` TEXT NOT NULL ,
`stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `hashtags` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`hash` TEXT NOT NULL ,
`count` INT NOT NULL 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `notifications` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`username` VARCHAR( 16 ) NOT NULL ,
`notify_type` INT NOT NULL ,
`notify_data` TEXT NOT NULL ,
`notify_msg` TEXT NOT NULL ,
`isSeen` ENUM( 'false', 'true' ) NOT NULL,
`stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `repository` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`status` INT( 1 ) NOT NULL DEFAULT '0' ,
`title` VARCHAR( 50 ) NOT NULL ,
`level` VARCHAR( 6 ) NOT NULL ,
`faculty` VARCHAR( 4 ) NOT NULL ,
`image`  VARCHAR( 32 ) NOT NULL,
`url` VARCHAR( 250 ) NOT NULL ,
`stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `shopping` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`username` VARCHAR( 16 ) NOT NULL ,
`status` INT( 1 ) NOT NULL DEFAULT '0' ,
`category` VARCHAR( 22 ) NOT NULL ,
`_condition` ENUM( 'New', 'Used' ) NOT NULL,
`price`  FLOAT NOT NULL ,
`title` VARCHAR( 25 ) NOT NULL ,
`image` VARCHAR( 32 ) NOT NULL ,
`description`  TEXT NOT NULL ,
`stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `digest` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`status` INT( 1 ) NOT NULL DEFAULT '0',
`category` VARCHAR( 15 ) NOT NULL,
`title` VARCHAR( 25 ) NOT NULL ,
`image`  VARCHAR( 32 ) NOT NULL,
`url` VARCHAR( 50 ) NOT NULL ,
`stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `transit` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`username` VARCHAR( 16 ) NOT NULL ,
`campus` ENUM( 'Bosso', 'Gidan Kwano' ) NOT NULL,
`means` ENUM( 'School Bus', 'Taxi' ) NOT NULL,
`time` VARCHAR( 16 ) NOT NULL ,
`stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `store_rating` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`username` VARCHAR( 16 ) NOT NULL ,
`target_username` VARCHAR( 16 ) NOT NULL ,
`rating`  FLOAT NOT NULL ,
`stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `report_user` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`username` VARCHAR( 16 ) NOT NULL ,
`target_username` VARCHAR( 16 ) NOT NULL ,
`report`  TEXT NOT NULL ,
`stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `report_feed` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`username` VARCHAR( 16 ) NOT NULL ,
`feedId`  INT NOT NULL ,
`stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `report_shop` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`username` VARCHAR( 16 ) NOT NULL ,
`shopId`  INT NOT NULL ,
`stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DELIMITER |

CREATE EVENT deleteInActiveAccount
    ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 DAY
    DO
      BEGIN
        DELETE FROM users WHERE isActive = 0;
      END |

DELIMITER ;



DELIMITER |

CREATE EVENT expireStore
    ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 DAY
    DO
      BEGIN
        UPDATE users SET hasStore = 'FALSE' WHERE DATE(`storeDate`) = DATE(NOW() - INTERVAL 1 WEEK);
      END |

DELIMITER ;



DELIMITER |

CREATE EVENT refreshOtpAttempt
    ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 DAY
    DO
      BEGIN
        UPDATE otp_sms SET attempt = 0 WHERE DATE(`created_at`) = DATE(NOW() - INTERVAL 1 DAY);
      END |

DELIMITER ;