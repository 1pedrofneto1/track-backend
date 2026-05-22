-- CreateEnum
CREATE TYPE "DocumentType" AS ENUM ('cpf', 'cnpj');

-- CreateEnum
CREATE TYPE "StorePlatform" AS ENUM ('shopify', 'nuvemshop');

-- CreateEnum
CREATE TYPE "CheckoutPlatform" AS ENUM ('shopify', 'yampi', 'cartpanda', 'adoorei', 'unicopag', 'nuvemshop');

-- CreateEnum
CREATE TYPE "AddToCartConfig" AS ENUM ('1', '2', '3');

-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('active', 'inactive', 'past_due');

-- CreateEnum
CREATE TYPE "SubscriptionProvider" AS ENUM ('asaas');

-- CreateEnum
CREATE TYPE "InvoiceStatus" AS ENUM ('pending', 'paid', 'overdue', 'cancelled');

-- CreateEnum
CREATE TYPE "PixelStatus" AS ENUM ('active', 'disabled', 'updating');

-- CreateEnum
CREATE TYPE "PixelPlatformType" AS ENUM ('facebook', 'google_ads', 'google_analytics4', 'tiktok', 'taboola', 'pinterest');

-- CreateEnum
CREATE TYPE "PlanLimitPlatformType" AS ENUM ('facebook', 'google_ads', 'google_analytics4', 'tiktok', 'taboola', 'pinterest');

-- CreateEnum
CREATE TYPE "ConfigPurchasePix" AS ENUM ('1', '2', '3');

-- CreateEnum
CREATE TYPE "ConfigPurchaseBillet" AS ENUM ('1', '2');

-- CreateTable
CREATE TABLE "user" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "email" CITEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "document_type" "DocumentType" NOT NULL,
    "document" CITEXT NOT NULL,
    "password" TEXT NOT NULL,
    "zip_code" TEXT NOT NULL,
    "street" TEXT NOT NULL,
    "district" TEXT NOT NULL,
    "number" TEXT NOT NULL,
    "complement" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "country" TEXT NOT NULL DEFAULT 'Brasil',
    "city" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plan" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "description" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "plan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plan_limit" (
    "id" UUID NOT NULL,
    "plan_id" UUID NOT NULL,
    "platform" "PlanLimitPlatformType" NOT NULL,
    "max_pixels" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "plan_limit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "store" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "name" TEXT NOT NULL,
    "store_domain" CITEXT NOT NULL,
    "checkout_url" TEXT NOT NULL,
    "add_to_cart_config" "AddToCartConfig",
    "high_ticket" DECIMAL(10,2),
    "extra_tag_manager" TEXT,
    "store_platform" "StorePlatform" NOT NULL,
    "checkout_platform" "CheckoutPlatform" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "store_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscription" (
    "id" UUID NOT NULL,
    "store_id" UUID NOT NULL,
    "plan_id" UUID NOT NULL,
    "status" "SubscriptionStatus" NOT NULL,
    "provider" "SubscriptionProvider" NOT NULL,
    "provider_subscription_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "subscription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoice" (
    "id" UUID NOT NULL,
    "subscription_id" UUID NOT NULL,
    "status" "InvoiceStatus" NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "due_at" TIMESTAMP(3) NOT NULL,
    "paid_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "invoice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pixel" (
    "id" UUID NOT NULL,
    "store_id" UUID NOT NULL,
    "label" TEXT NOT NULL,
    "status" "PixelStatus" NOT NULL DEFAULT 'active',
    "platform" "PixelPlatformType" NOT NULL,
    "config_purchase_pix" "ConfigPurchasePix",
    "config_purchase_billet" "ConfigPurchaseBillet",
    "api_token" TEXT,
    "pixel_code" TEXT,
    "test_code" TEXT,
    "merchant_id" TEXT,
    "conversion_id" TEXT,
    "pixel_name" TEXT,
    "conversion_label_purchase" TEXT,
    "conversion_label_initiate_checkout" TEXT,
    "conversion_label_add_to_cart" TEXT,
    "conversion_label_lead" TEXT,
    "conversion_label_view_item" TEXT,
    "conversion_label_view_category" TEXT,
    "measurement_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "pixel_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_document_key" ON "user"("document");

-- CreateIndex
CREATE UNIQUE INDEX "plan_name_key" ON "plan"("name");

-- CreateIndex
CREATE INDEX "plan_limit_plan_id_idx" ON "plan_limit"("plan_id");

-- CreateIndex
CREATE UNIQUE INDEX "plan_limit_plan_id_platform_key" ON "plan_limit"("plan_id", "platform");

-- CreateIndex
CREATE INDEX "store_user_id_idx" ON "store"("user_id");

-- CreateIndex
CREATE INDEX "store_store_domain_idx" ON "store"("store_domain");

-- CreateIndex
CREATE UNIQUE INDEX "subscription_provider_subscription_id_key" ON "subscription"("provider_subscription_id");

-- CreateIndex
CREATE INDEX "subscription_store_id_idx" ON "subscription"("store_id");

-- CreateIndex
CREATE INDEX "subscription_plan_id_idx" ON "subscription"("plan_id");

-- CreateIndex
CREATE INDEX "subscription_provider_subscription_id_idx" ON "subscription"("provider_subscription_id");

-- CreateIndex
CREATE INDEX "invoice_subscription_id_idx" ON "invoice"("subscription_id");

-- CreateIndex
CREATE INDEX "invoice_status_idx" ON "invoice"("status");

-- CreateIndex
CREATE INDEX "pixel_store_id_idx" ON "pixel"("store_id");

-- CreateIndex
CREATE INDEX "pixel_platform_idx" ON "pixel"("platform");

-- CreateIndex
CREATE INDEX "pixel_store_id_platform_idx" ON "pixel"("store_id", "platform");

-- AddForeignKey
ALTER TABLE "plan_limit" ADD CONSTRAINT "plan_limit_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "plan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "store" ADD CONSTRAINT "store_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription" ADD CONSTRAINT "subscription_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "store"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription" ADD CONSTRAINT "subscription_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "plan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice" ADD CONSTRAINT "invoice_subscription_id_fkey" FOREIGN KEY ("subscription_id") REFERENCES "subscription"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pixel" ADD CONSTRAINT "pixel_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "store"("id") ON DELETE CASCADE ON UPDATE CASCADE;
