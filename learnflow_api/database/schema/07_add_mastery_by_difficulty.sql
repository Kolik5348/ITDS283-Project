-- 07_add_mastery_by_difficulty.sql
USE learnflow;

ALTER TABLE topic_analysis
ADD COLUMN mastery_by_difficulty JSON DEFAULT NULL COMMENT 'JSON object: {easy: {mastery, level, action}, medium: {...}, hard: {...}}' AFTER level;

ALTER TABLE recommendations
ADD COLUMN mastery_by_difficulty JSON DEFAULT NULL COMMENT 'JSON object: {easy: {mastery, level, action}, medium: {...}, hard: {...}}' AFTER mastery;

