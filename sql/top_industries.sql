/* Calculates the frequency of industry selected during sign up for Moz Pro */
SELECT
  subs.subscription_id
  , subs.tier
  , subs.period
  , subs.start_date
  , subs.pay_start_date
  , subs.sku_id
  , subs.paying_month
  , e.str_value as industry
FROM mozdb.pipelines.subscriptions_base as subs
LEFT JOIN mozdb.import.nexus_user_extras as e
ON e.user_ID = subs.user_id
WHERE 1=1
AND e.key = 'profile-company_industry' /* grabs the industry info only*/
and e.str_value IS NOT NULL /* and they've chosen something... */
and LENGTH(e.str_value) > 0 /* blank strings are not interesting */
AND subs.END_DATE IS NULL /* active only */
AND subs.pay_start_date IS NOT NULL /* no non-paying customers */
and subs.calendar_date in (select max(calendar_date) from mozdb.pipelines.subscriptions_base) /* most recent data */
;
