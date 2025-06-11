-- CreateTable
CREATE TABLE `Roles` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Roles_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Users` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `full_name` VARCHAR(191) NULL,
    `username` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `mobile_number` VARCHAR(191) NOT NULL,
    `aws_type` ENUM('mega', 'mini', 'micro') NULL,
    `aws_date` DATETIME(3) NULL,
    `no_of_site` INTEGER NULL,
    `role_id` INTEGER NOT NULL,
    `parent_id` INTEGER NULL,
    `need_user_limit` BOOLEAN NOT NULL DEFAULT false,
    `sub_user_limit` INTEGER NULL,
    `status` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Users_username_key`(`username`),
    UNIQUE INDEX `Users_email_key`(`email`),
    UNIQUE INDEX `Users_mobile_number_key`(`mobile_number`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Zones` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `refrence_name` VARCHAR(191) NOT NULL,
    `actual_name` VARCHAR(191) NOT NULL,
    `user_id` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `SiteAccess` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `site_id` INTEGER NOT NULL,
    `access_role` VARCHAR(191) NULL,
    `assigned_by` INTEGER NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Sites` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `reference_name` VARCHAR(191) NOT NULL,
    `actual_name` VARCHAR(191) NOT NULL,
    `aws_type` ENUM('mega', 'mini', 'micro') NOT NULL,
    `zone_id` INTEGER NULL,
    `site_detail_id` INTEGER NOT NULL,
    `ward` VARCHAR(191) NOT NULL,
    `site_aws_type` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Sites_site_detail_id_key`(`site_detail_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Sitedetails` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `site_aws_concept` VARCHAR(191) NOT NULL,
    `ftp_img_prefix` VARCHAR(191) NOT NULL,
    `pc_serial_num` VARCHAR(191) NOT NULL,
    `sim_network` VARCHAR(191) NOT NULL,
    `sim_number` VARCHAR(191) NOT NULL,
    `anydesk` VARCHAR(191) NOT NULL,
    `machine_reg_no` VARCHAR(191) NOT NULL,
    `software_version` VARCHAR(191) NOT NULL,
    `location` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `RfEntries` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `imei` VARCHAR(191) NULL,
    `vehicle_no` VARCHAR(191) NULL,
    `rf_id` VARCHAR(191) NULL,
    `entry_dt` DATETIME(3) NULL,
    `user_id` INTEGER NOT NULL,
    `site_id` INTEGER NOT NULL,
    `zone_id` INTEGER NOT NULL,
    `entry_detail_id` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `RfEntries_entry_detail_id_key`(`entry_detail_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `RfEntryDetails` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `empty_weight` VARCHAR(191) NULL,
    `weight_per_kg` VARCHAR(191) NULL,
    `reference_value` VARCHAR(191) NULL,
    `max_weight` VARCHAR(191) NULL,
    `vehicle_type` VARCHAR(191) NULL,
    `cat` VARCHAR(191) NULL,
    `status` VARCHAR(191) NULL,
    `b_mcc` VARCHAR(191) NULL,
    `d_yard` VARCHAR(191) NULL,
    `over_weight` VARCHAR(191) NULL,
    `intime_limit` DATETIME(3) NULL,
    `out_time_limit` DATETIME(3) NULL,
    `temp_vehicle` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `AwsLogs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `site_id` INTEGER NOT NULL,
    `zone_id` INTEGER NOT NULL,
    `ward` VARCHAR(191) NULL,
    `imei` VARCHAR(191) NOT NULL,
    `vehicle_no` VARCHAR(191) NOT NULL,
    `rf_id` VARCHAR(191) NOT NULL,
    `empty_weight` DOUBLE NOT NULL,
    `weight_in` DOUBLE NOT NULL,
    `weight_out` DOUBLE NOT NULL,
    `date_in` DATETIME(3) NOT NULL,
    `date_out` DATETIME(3) NOT NULL,
    `status` VARCHAR(191) NOT NULL,
    `in_status` VARCHAR(191) NOT NULL,
    `out_status` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `AwsLogGeneralDetails` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `awslog_id` INTEGER NOT NULL,
    `hash_value` VARCHAR(191) NOT NULL,
    `trip` VARCHAR(191) NOT NULL,
    `trip_km` VARCHAR(191) NOT NULL,
    `trip_missed_assign` VARCHAR(191) NOT NULL,
    `b_mcc` VARCHAR(191) NOT NULL,
    `d_yard` VARCHAR(191) NOT NULL,
    `cat` VARCHAR(191) NOT NULL,
    `out_auto_alert` VARCHAR(191) NOT NULL,
    `delay_assign` VARCHAR(191) NOT NULL,
    `to_ear_assign` VARCHAR(191) NOT NULL,
    `overload_assign` VARCHAR(191) NOT NULL,
    `coordinates` JSON NULL,

    UNIQUE INDEX `AwsLogGeneralDetails_awslog_id_key`(`awslog_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `AwsLogInImages` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `awslog_id` INTEGER NOT NULL,
    `front_in` VARCHAR(191) NOT NULL,
    `back_in` VARCHAR(191) NOT NULL,
    `left_in` VARCHAR(191) NOT NULL,
    `right_in` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `AwsLogInImages_awslog_id_key`(`awslog_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `AwsLogOutImages` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `awslog_id` INTEGER NOT NULL,
    `front_out` VARCHAR(191) NOT NULL,
    `back_out` VARCHAR(191) NOT NULL,
    `left_out` VARCHAR(191) NOT NULL,
    `right_out` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `AwsLogOutImages_awslog_id_key`(`awslog_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `AwsMicroLogs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `user_id` INTEGER NOT NULL,
    `site_id` INTEGER NOT NULL,
    `zone_id` INTEGER NOT NULL,
    `imei` VARCHAR(191) NOT NULL,
    `vehicle_no` VARCHAR(191) NOT NULL,
    `rf_id` VARCHAR(191) NOT NULL,
    `trip` VARCHAR(191) NOT NULL,
    `date` DATETIME(3) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `AwsMicroLogDetails` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `aws_micro_log_id` INTEGER NOT NULL,
    `data` JSON NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `AwsMicroLogDetails_aws_micro_log_id_key`(`aws_micro_log_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Users` ADD CONSTRAINT `Users_role_id_fkey` FOREIGN KEY (`role_id`) REFERENCES `Roles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Users` ADD CONSTRAINT `Users_parent_id_fkey` FOREIGN KEY (`parent_id`) REFERENCES `Users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Zones` ADD CONSTRAINT `Zones_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `SiteAccess` ADD CONSTRAINT `SiteAccess_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `SiteAccess` ADD CONSTRAINT `SiteAccess_site_id_fkey` FOREIGN KEY (`site_id`) REFERENCES `Sites`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Sites` ADD CONSTRAINT `Sites_zone_id_fkey` FOREIGN KEY (`zone_id`) REFERENCES `Zones`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Sites` ADD CONSTRAINT `Sites_site_detail_id_fkey` FOREIGN KEY (`site_detail_id`) REFERENCES `Sitedetails`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RfEntries` ADD CONSTRAINT `RfEntries_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RfEntries` ADD CONSTRAINT `RfEntries_site_id_fkey` FOREIGN KEY (`site_id`) REFERENCES `Sites`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RfEntries` ADD CONSTRAINT `RfEntries_zone_id_fkey` FOREIGN KEY (`zone_id`) REFERENCES `Zones`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RfEntries` ADD CONSTRAINT `RfEntries_entry_detail_id_fkey` FOREIGN KEY (`entry_detail_id`) REFERENCES `RfEntryDetails`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogs` ADD CONSTRAINT `AwsLogs_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogs` ADD CONSTRAINT `AwsLogs_site_id_fkey` FOREIGN KEY (`site_id`) REFERENCES `Sites`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogs` ADD CONSTRAINT `AwsLogs_zone_id_fkey` FOREIGN KEY (`zone_id`) REFERENCES `Zones`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogGeneralDetails` ADD CONSTRAINT `AwsLogGeneralDetails_awslog_id_fkey` FOREIGN KEY (`awslog_id`) REFERENCES `AwsLogs`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogInImages` ADD CONSTRAINT `AwsLogInImages_awslog_id_fkey` FOREIGN KEY (`awslog_id`) REFERENCES `AwsLogs`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogOutImages` ADD CONSTRAINT `AwsLogOutImages_awslog_id_fkey` FOREIGN KEY (`awslog_id`) REFERENCES `AwsLogs`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsMicroLogs` ADD CONSTRAINT `AwsMicroLogs_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsMicroLogs` ADD CONSTRAINT `AwsMicroLogs_site_id_fkey` FOREIGN KEY (`site_id`) REFERENCES `Sites`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsMicroLogs` ADD CONSTRAINT `AwsMicroLogs_zone_id_fkey` FOREIGN KEY (`zone_id`) REFERENCES `Zones`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsMicroLogDetails` ADD CONSTRAINT `AwsMicroLogDetails_aws_micro_log_id_fkey` FOREIGN KEY (`aws_micro_log_id`) REFERENCES `AwsMicroLogs`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
