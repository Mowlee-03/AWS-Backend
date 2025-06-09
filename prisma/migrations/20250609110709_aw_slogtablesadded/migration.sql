/*
  Warnings:

  - You are about to drop the column `user_id` on the `sites` table. All the data in the column will be lost.
  - Added the required column `updated_at` to the `RfEntries` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `RfEntryDetails` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `sites` DROP FOREIGN KEY `Sites_user_id_fkey`;

-- DropIndex
DROP INDEX `Sites_user_id_fkey` ON `sites`;

-- AlterTable
ALTER TABLE `rfentries` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL;

-- AlterTable
ALTER TABLE `rfentrydetails` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL;

-- AlterTable
ALTER TABLE `sites` DROP COLUMN `user_id`;

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
    `awslog_in` INTEGER NOT NULL,
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

    UNIQUE INDEX `AwsLogGeneralDetails_awslog_in_key`(`awslog_in`),
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

-- AddForeignKey
ALTER TABLE `SiteAccess` ADD CONSTRAINT `SiteAccess_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `SiteAccess` ADD CONSTRAINT `SiteAccess_site_id_fkey` FOREIGN KEY (`site_id`) REFERENCES `Sites`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogs` ADD CONSTRAINT `AwsLogs_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogs` ADD CONSTRAINT `AwsLogs_site_id_fkey` FOREIGN KEY (`site_id`) REFERENCES `Sites`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogs` ADD CONSTRAINT `AwsLogs_zone_id_fkey` FOREIGN KEY (`zone_id`) REFERENCES `Zones`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogGeneralDetails` ADD CONSTRAINT `AwsLogGeneralDetails_awslog_in_fkey` FOREIGN KEY (`awslog_in`) REFERENCES `AwsLogs`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogInImages` ADD CONSTRAINT `AwsLogInImages_awslog_id_fkey` FOREIGN KEY (`awslog_id`) REFERENCES `AwsLogs`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AwsLogOutImages` ADD CONSTRAINT `AwsLogOutImages_awslog_id_fkey` FOREIGN KEY (`awslog_id`) REFERENCES `AwsLogs`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
