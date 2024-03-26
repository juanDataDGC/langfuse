-- AlterEnum
ALTER TYPE "ScoreSource" ADD VALUE 'MODEL_BASED_EVALUATION';

-- CreateTable
CREATE TABLE "eval_templates" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "project_id" TEXT,
    "name" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "prompt" TEXT NOT NULL,
    "model" TEXT NOT NULL,
    "model_params" JSONB NOT NULL,
    "vars" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "output_schema" JSONB NOT NULL,

    CONSTRAINT "eval_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "job_configurations" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "project_id" TEXT NOT NULL,
    "job_type" TEXT NOT NULL,
    "eval_template_id" TEXT,
    "score_name" TEXT NOT NULL,
    "filter" JSONB NOT NULL,
    "target_object" TEXT NOT NULL,
    "variable_mapping" JSONB NOT NULL,
    "sampling" DECIMAL(65,30) NOT NULL,
    "delay" INTEGER NOT NULL,

    CONSTRAINT "job_configurations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "job_executions" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "project_id" TEXT NOT NULL,
    "job_configuration_id" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "start_time" TIMESTAMP(3),
    "end_time" TIMESTAMP(3),
    "error" TEXT,
    "trace_id" TEXT,
    "score_id" TEXT,

    CONSTRAINT "job_executions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "eval_templates_project_id_id_idx" ON "eval_templates"("project_id", "id");

-- CreateIndex
CREATE INDEX "eval_templates_project_id_idx" ON "eval_templates"("project_id");

-- CreateIndex
CREATE INDEX "job_configurations_project_id_id_idx" ON "job_configurations"("project_id", "id");

-- CreateIndex
CREATE INDEX "job_configurations_project_id_idx" ON "job_configurations"("project_id");

-- CreateIndex
CREATE INDEX "job_executions_project_id_id_idx" ON "job_executions"("project_id", "id");

-- CreateIndex
CREATE INDEX "job_executions_project_id_idx" ON "job_executions"("project_id");

-- AddForeignKey
ALTER TABLE "eval_templates" ADD CONSTRAINT "eval_templates_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_configurations" ADD CONSTRAINT "job_configurations_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_configurations" ADD CONSTRAINT "job_configurations_eval_template_id_fkey" FOREIGN KEY ("eval_template_id") REFERENCES "eval_templates"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_executions" ADD CONSTRAINT "job_executions_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_executions" ADD CONSTRAINT "job_executions_job_configuration_id_fkey" FOREIGN KEY ("job_configuration_id") REFERENCES "job_configurations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_executions" ADD CONSTRAINT "job_executions_trace_id_fkey" FOREIGN KEY ("trace_id") REFERENCES "traces"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_executions" ADD CONSTRAINT "job_executions_score_id_fkey" FOREIGN KEY ("score_id") REFERENCES "scores"("id") ON DELETE SET NULL ON UPDATE CASCADE;