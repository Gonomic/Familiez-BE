USE humans;

ALTER TABLE humans.marriages
    ADD COLUMN IF NOT EXISTS StartDateStatus TINYINT NOT NULL DEFAULT 1
        COMMENT '1=exact, 2=estimated' AFTER StartDate,
    ADD COLUMN IF NOT EXISTS EndDateStatus TINYINT NULL DEFAULT NULL
        COMMENT '1=exact, 2=estimated; null when no end date is set' AFTER EndDate;

UPDATE humans.marriages
SET EndDateStatus = 1
WHERE EndDate IS NOT NULL
  AND EndDateStatus IS NULL;