/*
  Warnings:

  - You are about to drop the `role` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `site` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sitedetail` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `zone` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `site` DROP FOREIGN KEY `Site_user_id_fkey`;

-- DropForeignKey
ALTER TABLE `site` DROP FOREIGN KEY `Site_zone_id_fkey`;

-- DropForeignKey
ALTER TABLE `sitedetail` DROP FOREIGN KEY `Sitedetail_site_id_fkey`;

-- DropForeignKey
ALTER TABLE `user` DROP FOREIGN KEY `User_parent_id_fkey`;

-- DropForeignKey
ALTER TABLE `user` DROP FOREIGN KEY `User_role_id_fkey`;

-- DropForeignKey
ALTER TABLE `zone` DROP FOREIGN KEY `Zone_user_id_fkey`;

-- DropTable
DROP TABLE `role`;

-- DropTable
DROP TABLE `site`;

-- DropTable
DROP TABLE `sitedetail`;

-- DropTable
DROP TABLE `user`;

-- DropTable
DROP TABLE `zone`;

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
    `id` INTEGER NOT NULL,
    `refrence_name` VARCHAR(191) NOT NULL,
    `actual_name` VARCHAR(191) NOT NULL,
    `user_id` INTEGER NOT NULL,
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
    `user_id` INTEGER NOT NULL,
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
    `zone_id` INTEGER NULL,
    `entry_detail_id` INTEGER NOT NULL,

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

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Users` ADD CONSTRAINT `Users_role_id_fkey` FOREIGN KEY (`role_id`) REFERENCES `Roles`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Users` ADD CONSTRAINT `Users_parent_id_fkey` FOREIGN KEY (`parent_id`) REFERENCES `Users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Zones` ADD CONSTRAINT `Zones_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Sites` ADD CONSTRAINT `Sites_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Sites` ADD CONSTRAINT `Sites_zone_id_fkey` FOREIGN KEY (`zone_id`) REFERENCES `Zones`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Sites` ADD CONSTRAINT `Sites_site_detail_id_fkey` FOREIGN KEY (`site_detail_id`) REFERENCES `Sitedetails`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RfEntries` ADD CONSTRAINT `RfEntries_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RfEntries` ADD CONSTRAINT `RfEntries_site_id_fkey` FOREIGN KEY (`site_id`) REFERENCES `Sites`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RfEntries` ADD CONSTRAINT `RfEntries_zone_id_fkey` FOREIGN KEY (`zone_id`) REFERENCES `Zones`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RfEntries` ADD CONSTRAINT `RfEntries_entry_detail_id_fkey` FOREIGN KEY (`entry_detail_id`) REFERENCES `RfEntryDetails`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
