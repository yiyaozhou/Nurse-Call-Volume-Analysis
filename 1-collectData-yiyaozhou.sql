/* This is the SQL query used to collect nurse call data.
4 tables are used in this query
messages: payload|recipientUserName|timeDelivered
user: userID|userName
user_unit_tracking: timestamp|userId|unitId
hierarchy: levelName|unitId|hospitalId */

ISNULL(hosp.levelName, 'N/A') AS 'Recipient Hospital', 
ISNULL(unit.levelName, 'N/A') AS 'Recipient Unit', 
m.recipientId AS 'Recipient ID', 
SUBSTRING(m.payload, CHARINDEX('|', m.payload, 1) + 1, CHARINDEX('|', m.payload, 11)-CHARINDEX('|', m.payload, 1) - 1) AS 'Message Type', -- Extract the message type from "payload"
DATEPART(MONTH, m.timeDelivered) AS 'Month', 
DATEPART(HOUR,m.timeDelivered) AS 'Hour', 
-- 30 minutes interval, if 0-30, return 0; if 30-60, return 1
ROUND(DATEPART(MINUTE,timeDelivered)/30, 0) AS '30-Min', 
COUNT(*) AS 'Count' 

FROM messages m 
LEFT JOIN 
    user u 
/* The unit of a user changes when his/her location changes.
user_unit_tracking audits the timestamp, unitId and userId every time the user's location changes
The following part was used to find the most recent unit before the message received time */
ON 
    u.userName = m.recipientUserName OUTER apply 
    ( 
        SELECT 
            top 1 t.unitId 
        FROM 
            user_unit_tracking t 
        WHERE 
            t.userId = u.userId 
        AND t.timestamp <= m.timeReceived 
        ORDER BY 
            t.timestamp DESC ) AS last_unit 
LEFT JOIN 
    hierarchy unit 
ON 
    unit.levelid = last_unit.unitid 
LEFT JOIN 
    hierarchy AS hosp --self join to get the hospital level information
ON 
    hosp.levelid = unit.hospitalid 

WHERE m.timeDelivered >'2017-07-01' 
AND m.timeDelivered <'2018-07-01' 

GROUP BY 
ISNULL(hosp.levelName, 'N/A'), 
ISNULL(unit.levelName, 'N/A'), 
DATEPART(MONTH, timeDelivered), 
DATEPART(HOUR,timeDelivered), 
ROUND(DATEPART(MINUTE,timeDelivered)/30, 0), 
SUBSTRING(m.payload, CHARINDEX('|', m.payload, 1)+1, CHARINDEX('|', m.payload, 11)-CHARINDEX('|', m.payload, 1)-1), 
m.recipientId 

ORDER BY 
ISNULL(hosp.levelName, 'N/A'), 
ISNULL(unit.levelName, 'N/A'), 
DATEPART(HOUR,timeDelivered), 
ROUND(DATEPART(MINUTE,timeDelivered)/30, 0)