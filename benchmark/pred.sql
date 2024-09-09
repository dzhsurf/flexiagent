SELECT MAX("Percent (%) Eligible Free (K-12)") FROM "frpm" WHERE "County Name" = 'Alameda County'	california_schools
SELECT "School Name", "Percent (%) Eligible Free (Ages 5-17)" FROM frpm WHERE "School Type" = 'Continuation' ORDER BY "Percent (%) Eligible Free (Ages 5-17)" LIMIT 3;	california_schools
SELECT "Zip" FROM "schools" WHERE "County" = 'Fresno' AND "Charter" = 1	california_schools
SELECT "MailStreet" FROM "schools" JOIN "frpm" ON "schools"."CDSCode" = "frpm"."CDSCode" ORDER BY "FRPM Count (K-12)" DESC LIMIT 1	california_schools
SELECT "s"."Phone" FROM "schools" AS "s" JOIN "frpm" AS "f" ON "s"."CDSCode" = "f"."CDSCode" WHERE "f"."Charter Funding Type" = 'Direct' AND "s"."OpenDate" > '2000-01-01';	california_schools
SELECT COUNT(DISTINCT "sname") FROM "satscores" JOIN "schools" ON "satscores"."cds" = "schools"."CDSCode" WHERE "AvgScrMath" > 400 AND "Virtual" = 'Y';	california_schools
SELECT "s"."School", "s"."District", "s"."County" FROM "satscores" AS "s" JOIN "schools" AS "sc" ON "s"."cds" = "sc"."CDSCode" WHERE "s"."NumTstTakr" > 500 AND "sc"."Magnet" = 1	california_schools
SELECT "Phone" FROM "schools" JOIN "satscores" ON "schools"."CDSCode" = "satscores"."cds" WHERE "satscores"."NumTstTakr" = (SELECT MAX("NumTstTakr") FROM "satscores" WHERE "NumGE1500" > 0)	california_schools
SELECT "NumTstTakr" FROM "satscores" WHERE "cds" IN (SELECT "CDSCode" FROM "frpm" ORDER BY "FRPM Count (K-12)" DESC LIMIT 1)	california_schools
SELECT COUNT(DISTINCT "sname") FROM "satscores" JOIN "schools" ON "satscores"."cds" = "schools"."CDSCode" WHERE "AvgScrMath" > 560 AND "schools"."FundingType" = 'Charter'	california_schools
SELECT "frpm"."FRPM Count (Ages 5-17)" FROM "frpm" JOIN "satscores" ON "frpm"."CDSCode" = "satscores"."cds" WHERE "satscores"."AvgScrRead" = (SELECT MAX("AvgScrRead") FROM "satscores")	california_schools
SELECT "CDSCode" FROM "frpm" WHERE "Enrollment (K-12)" > 500	california_schools
SELECT MAX("Percent (%) Eligible Free (Ages 5-17)") FROM "frpm" JOIN "satscores" ON "frpm"."CDSCode" = "satscores"."cds" WHERE "NumGE1500" / "NumTstTakr" > 0.3;	california_schools
SELECT "s"."Phone" FROM "satscores" AS "sat" JOIN "schools" AS "s" ON "sat"."cds" = "s"."CDSCode" ORDER BY ("NumGE1500" * 1.0 / "NumTstTakr") DESC LIMIT 3;	california_schools
SELECT "NCESSchool", "Enrollment (Ages 5-17)" FROM "frpm" ORDER BY "Enrollment (Ages 5-17)" DESC LIMIT 5	california_schools
SELECT "dname", AVG("AvgScrRead") AS "AverageReadingScore" FROM "satscores" JOIN "schools" ON "satscores"."cds" = "schools"."CDSCode" WHERE "schools"."StatusType" = 'Active' GROUP BY "dname" ORDER BY "AverageReadingScore" DESC LIMIT 1	california_schools
SELECT COUNT(*) FROM satscores s JOIN schools sch ON s.cds = sch."CDSCode" WHERE sch."County" = 'Alameda' AND s."NumTstTakr" < 100;	california_schools
SELECT "satscores"."sname", "satscores"."AvgScrWrite", "schools"."CharterNum" FROM "satscores" JOIN "schools" ON "satscores"."cds" = "schools"."CDSCode" WHERE "satscores"."AvgScrWrite" > 499 ORDER BY "satscores"."AvgScrWrite" DESC	california_schools
SELECT COUNT("sname") FROM "satscores" JOIN "schools" ON "satscores"."cds" = "schools"."CDSCode" WHERE "schools"."County" = 'Fresno' AND "satscores"."NumTstTakr" <= 250 AND "schools"."FundingType" = 'Directly Funded';	california_schools
SELECT "s"."Phone" FROM "satscores" AS "s" JOIN "schools" AS "sch" ON "s"."cds" = "sch"."CDSCode" ORDER BY "s"."AvgScrMath" DESC LIMIT 1	california_schools
SELECT COUNT("School Name") FROM "frpm" WHERE "County Name" = 'Amador' AND "Low Grade" = '9' AND "High Grade" = '12';	california_schools
SELECT COUNT("School Name") FROM "frpm" WHERE "County Name" = 'Los Angeles' AND "Free Meal Count (K-12)" > 500 AND "FRPM Count (K-12)" < 700	california_schools
SELECT "s"."School", "s"."District", "sa"."NumTstTakr" FROM "schools" AS "s" JOIN "satscores" AS "sa" ON "s"."CDSCode" = "sa"."cds" WHERE "s"."County" = 'Contra Costa' ORDER BY "sa"."NumTstTakr" DESC LIMIT 1	california_schools
SELECT "School Name", "Street", "City", "Zip" FROM "frpm" JOIN "schools" ON "frpm"."CDSCode" = "schools"."CDSCode" WHERE ABS("Enrollment (K-12)" - "Enrollment (Ages 5-17)") > 30;	california_schools
SELECT "schools"."School" FROM "schools" JOIN "frpm" ON "schools"."CDSCode" = "frpm"."CDSCode" JOIN "satscores" ON "schools"."CDSCode" = "satscores"."cds" WHERE "frpm"."Percent (%) Eligible Free (K-12)" > 0.1 AND "satscores"."NumTstTakr" > 0 AND "satscores"."NumGE1500" > 0;	california_schools
SELECT "schools"."School", "schools"."FundingType" FROM "schools" JOIN "satscores" ON "schools"."CDSCode" = "satscores"."cds" WHERE "schools"."County" = 'Riverside' AND "satscores"."AvgScrMath" > 400;	california_schools
SELECT "School Name", "Street", "City", "Zip", "State" FROM frpm JOIN schools ON frpm."CDSCode" = schools."CDSCode" WHERE frpm."County Name" = 'Monterey' AND frpm."Free Meal Count (Ages 5-17)" > 800 AND frpm."High Grade" = '12'	california_schools
SELECT "schools"."School", "satscores"."AvgScrWrite", "schools"."Phone" FROM "schools" JOIN "satscores" ON "schools"."CDSCode" = "satscores"."cds" WHERE "schools"."OpenDate" > '1991-01-01' OR "schools"."ClosedDate" < '2000-01-01';	california_schools
SELECT "s"."School", "s"."DOCType" FROM "schools" AS "s" JOIN "frpm" AS "f" ON "s"."CDSCode" = "f"."CDSCode" WHERE "f"."Enrollment (K-12)" - "f"."Enrollment (Ages 5-17)" > (SELECT AVG("f2"."Enrollment (K-12)" - "f2"."Enrollment (Ages 5-17)") FROM "frpm" AS "f2" JOIN "schools" AS "s2" ON "f2"."CDSCode" = "s2"."CDSCode" WHERE "s2"."FundingType" = 'Locally Funded');	california_schools
SELECT "OpenDate" FROM "schools" WHERE "School" IN (SELECT "School Name" FROM "frpm" WHERE "Low Grade" = '1' AND "High Grade" = '12' ORDER BY "Enrollment (K-12)" DESC LIMIT 1)	california_schools
SELECT "City", SUM("Enrollment (K-12)") AS "Total Enrollment" FROM "schools" JOIN "frpm" ON "schools"."CDSCode" = "frpm"."CDSCode" GROUP BY "City" ORDER BY "Total Enrollment" ASC LIMIT 5;	california_schools
SELECT "School Name", "Enrollment (K-12)", "Percent (%) Eligible Free (K-12)" FROM frpm ORDER BY "Enrollment (K-12)" DESC LIMIT 11 OFFSET 9;	california_schools
SELECT "School Name", "FRPM Count (K-12)", "Percent (%) Eligible FRPM (K-12)" FROM frpm WHERE "Charter School (Y/N)" = 66 ORDER BY "FRPM Count (K-12)" DESC LIMIT 5;	california_schools
SELECT "schools"."School", "schools"."Website" FROM "frpm" JOIN "schools" ON "frpm"."CDSCode" = "schools"."CDSCode" WHERE "frpm"."Free Meal Count (Ages 5-17)" BETWEEN 1900 AND 2000;	california_schools
SELECT "Percent (%) Eligible Free (Ages 5-17)" FROM "frpm" JOIN "schools" ON "frpm"."CDSCode" = "schools"."CDSCode" WHERE "AdmFName1" = 'Kacey' AND "AdmLName1" = 'Gibson'	california_schools
SELECT "AdmEmail1" FROM "schools" JOIN "frpm" ON "schools"."CDSCode" = "frpm"."CDSCode" WHERE "frpm"."Charter School (Y/N)" = 1 ORDER BY "frpm"."Enrollment (K-12)" ASC LIMIT 1	california_schools
SELECT "AdmFName1", "AdmLName1", "AdmFName2", "AdmLName2", "AdmFName3", "AdmLName3" FROM "schools" JOIN "satscores" ON "schools"."CDSCode" = "satscores"."cds" WHERE "NumGE1500" = (SELECT MAX("NumGE1500") FROM "satscores");	california_schools
SELECT "Street", "City", "Zip", "State" FROM "schools" WHERE "CDSCode" = (SELECT "cds" FROM "satscores" ORDER BY "AvgScrRead" ASC LIMIT 1)	california_schools
SELECT "Website" FROM "schools" WHERE "County" = 'Los Angeles' AND "CDSCode" IN (SELECT "cds" FROM "satscores" WHERE "NumTstTakr" BETWEEN 2000 AND 3000)	california_schools
SELECT AVG("NumTstTakr") FROM "satscores" JOIN "schools" ON "satscores"."cds" = "schools"."CDSCode" WHERE "schools"."OpenDate" BETWEEN '1980-01-01' AND '1980-12-31' AND "schools"."County" = 'Fresno';	california_schools
SELECT "Phone" FROM "schools" WHERE "School" IN (SELECT "sname" FROM "satscores" WHERE "dname" = 'Fresno Unified' ORDER BY "AvgScrRead" ASC LIMIT 1)	california_schools
SELECT "s"."School", "s"."County" FROM "satscores" "sat" JOIN "schools" "s" ON "sat"."cds" = "s"."CDSCode" WHERE "s"."Virtual" = 'Y' ORDER BY "sat"."AvgScrRead" DESC LIMIT 5;	california_schools
SELECT "Educational Option Type" FROM "frpm" WHERE "CDSCode" = (SELECT "cds" FROM "satscores" ORDER BY "AvgScrMath" DESC LIMIT 1)	california_schools
SELECT "sname", "dname", AVG("AvgScrMath") AS "AverageMathScore" FROM "satscores" WHERE "cds" = (SELECT "cds" FROM "satscores" ORDER BY (AVG("AvgScrRead") + AVG("AvgScrMath") + AVG("AvgScrWrite")) ASC LIMIT 1) GROUP BY "sname", "dname"	california_schools
SELECT "satscores"."AvgScrWrite", "schools"."City" FROM "satscores" JOIN "schools" ON "satscores"."cds" = "schools"."CDSCode" WHERE "satscores"."NumGE1500" > 0 ORDER BY "satscores"."NumTstTakr" DESC LIMIT 1;	california_schools
SELECT "s"."School", AVG("sa"."AvgScrWrite") AS "Average_Writing_Score" FROM "schools" AS "s" JOIN "satscores" AS "sa" ON "s"."CDSCode" = "sa"."cds" WHERE "s"."AdmFName1" = 'Ricci' AND "s"."AdmLName1" = 'Ulrich' GROUP BY "s"."School"	california_schools
SELECT "sname", SUM("enroll12") AS "total_enrollment" FROM "satscores" WHERE "rtype" = 'State Special' GROUP BY "sname" ORDER BY "total_enrollment" DESC LIMIT 1	california_schools
SELECT COUNT("School") / 12.0 AS "Monthly_Average" FROM "schools" WHERE "County" = 'Alameda' AND "District" LIKE '%Elementary School District%' AND strftime('%Y', "OpenDate") = '1980';	california_schools
SELECT (SELECT COUNT(*) FROM "frpm" WHERE "County Name" = 'Orange' AND "District Type" = 'Unified') AS UnifiedSchools, (SELECT COUNT(*) FROM "frpm" WHERE "County Name" = 'Orange' AND "District Type" = 'Elementary') AS ElementarySchools;	california_schools
SELECT "County", "School", "ClosedDate" FROM "schools" WHERE "ClosedDate" IS NOT NULL GROUP BY "County" ORDER BY COUNT("School") DESC LIMIT 1	california_schools
SELECT "School", "Street", "City", "Zip" FROM "satscores" JOIN "schools" ON "satscores"."cds" = "schools"."CDSCode" ORDER BY "AvgScrMath" DESC LIMIT 1 OFFSET 6;	california_schools
SELECT "MailStreet", "School" FROM "schools" JOIN "satscores" ON "schools"."CDSCode" = "satscores"."cds" WHERE "AvgScrRead" = (SELECT MIN("AvgScrRead") FROM "satscores");	california_schools
SELECT COUNT(DISTINCT "s"."School") AS "TotalSchools" FROM "satscores" "s" JOIN "schools" "sc" ON "s"."cds" = "sc"."CDSCode" WHERE "s"."NumGE1500" >= 1 AND "sc"."MailCity" = 'Lakeport';	california_schools
SELECT SUM("NumTstTakr") FROM "satscores" WHERE "cname" IN (SELECT "MailCity" FROM "schools" WHERE "MailCity" = 'Fresno')	california_schools
SELECT "School", "MailZip" FROM "schools" WHERE "AdmFName1" = 'Avetik' AND "AdmLName1" = 'Atoian'	california_schools
SELECT (SELECT COUNT(*) FROM schools WHERE "MailState" = 'California' AND "County" = 'Colusa') * 1.0 / (SELECT COUNT(*) FROM schools WHERE "MailState" = 'California' AND "County" = 'Humboldt') AS "Ratio"	california_schools
SELECT COUNT("School") FROM "schools" WHERE "State" = 'CA' AND "StatusType" = 'Active' AND "City" = 'San Joaquin'	california_schools
SELECT "Phone", "Ext" FROM "satscores" JOIN "schools" ON "satscores"."cds" = "schools"."CDSCode" ORDER BY "AvgScrWrite" DESC LIMIT 1 OFFSET 332;	california_schools
SELECT "School", "Phone", "Ext" FROM "schools" WHERE "Zip" = '95203-3704'	california_schools
SELECT "Website" FROM "schools" WHERE "AdmFName1" IN ('Mike', 'Dante') AND "AdmLName1" IN ('Larson', 'Alvarez')	california_schools
SELECT "Website" FROM "schools" WHERE "County" = 'San Joaquin' AND "Charter" = 1 AND "Virtual" = 'Partially Virtual';	california_schools
SELECT COUNT("schools"."School") AS "CharteredSchoolCount" FROM "schools" JOIN "frpm" ON "schools"."CDSCode" = "frpm"."CDSCode" WHERE "schools"."City" = 'Hickman' AND "frpm"."District Type" = 'Elementary' AND "frpm"."Charter School (Y/N)" = 1;	california_schools
SELECT COUNT(*) FROM "frpm" WHERE "County Name" = 'Los Angeles' AND "Percent (%) Eligible Free (K-12)" < 0.18 AND "Charter School (Y/N)" = 0;	california_schools
SELECT "s"."School", "s"."City", "s"."AdmFName1", "s"."AdmLName1", "s"."AdmFName2", "s"."AdmLName2", "s"."AdmFName3", "s"."AdmLName3" FROM "schools" AS "s" JOIN "frpm" AS "f" ON "s"."CDSCode" = "f"."CDSCode" WHERE "f"."Charter School Number" = '00D2'	california_schools
SELECT COUNT("School") AS total_schools FROM "schools" WHERE "MailCity" = 'Hickman' AND "CharterNum" = '00D4';	california_schools
SELECT (SUM(CASE WHEN "FundingType" = 'Locally Funded' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS "LocallyFundedPercentage" FROM schools WHERE "County" = 'Santa Clara';	california_schools
SELECT COUNT("CDSCode") FROM "schools" WHERE "OpenDate" BETWEEN '2000-01-01' AND '2005-12-31' AND "County" = 'Stanislaus' AND "FundingType" = 'Directly Funded';	california_schools
SELECT COUNT(*) AS "TotalClosure" FROM "schools" WHERE "ClosedDate" BETWEEN '1989-01-01' AND '1989-12-31' AND "City" = 'San Francisco' AND "StatusType" = 'Community College District';	california_schools
SELECT "County Name", COUNT(*) AS "ClosureCount" FROM "frpm" JOIN "schools" ON "frpm"."CDSCode" = "schools"."CDSCode" WHERE "schools"."ClosedDate" BETWEEN '1980-01-01' AND '1989-12-31' AND "schools"."Charter" = 'CEA' GROUP BY "County Name" ORDER BY "ClosureCount" DESC LIMIT 1;	california_schools
SELECT "NCESDist" FROM "schools" WHERE "SOC" = 'State Special Schools'	california_schools
SELECT COUNT(*) AS "ActiveCount" FROM "frpm" WHERE "County Name" = 'Alpine' AND "District Type" = 'District Community Day School' AND "School Type" = 'Active'; SELECT COUNT(*) AS "ClosedCount" FROM "frpm" WHERE "County Name" = 'Alpine' AND "District Type" = 'District Community Day School' AND "School Type" = 'Closed';	california_schools
SELECT "District Code" FROM "frpm" WHERE "School Code" IN (SELECT "CDSCode" FROM "schools" WHERE "City" = 'Fresno' AND "Magnet" = 0)	california_schools
SELECT "Enrollment (Ages 5-17)" FROM "frpm" WHERE "School Name" = 'State Special School' AND "County Name" = 'Fremont' AND "Academic Year" = '2014-2015'	california_schools
SELECT "Free Meal Count (Ages 5-17)" FROM frpm JOIN schools ON frpm."CDSCode" = schools."CDSCode" WHERE schools."MailStreet" = 'PO Box 1040' AND schools."School" LIKE '%Youth Authority School%'	california_schools
SELECT "Low Grade" FROM "frpm" JOIN "schools" ON "frpm"."CDSCode" = "schools"."CDSCode" WHERE "schools"."NCESDist" = '0613360' AND "schools"."School" = 'District Special Education Consortia School'	california_schools
SELECT "School Name" FROM frpm WHERE "NSLP Provision Status" = '2' AND "County Code" = '37'	california_schools
SELECT "s"."City" FROM "frpm" AS "f" JOIN "schools" AS "s" ON "f"."CDSCode" = "s"."CDSCode" WHERE "f"."NSLP Provision Status" = '2' AND "f"."Low Grade" = '9' AND "f"."High Grade" = '12' AND "f"."County Name" = 'Merced' AND "f"."School Type" = 'High School';	california_schools
SELECT "frpm"."School Name", "frpm"."Percent (%) Eligible FRPM (Ages 5-17)" FROM "frpm" JOIN "schools" ON "frpm"."CDSCode" = "schools"."CDSCode" WHERE "frpm"."Low Grade" = 'K' AND "frpm"."High Grade" = '9' AND "schools"."County" = 'Los Angeles';	california_schools
SELECT "Low Grade", "High Grade", COUNT(*) AS "Count" FROM frpm JOIN schools ON frpm."CDSCode" = schools."CDSCode" WHERE schools."City" = 'Adelanto' GROUP BY "Low Grade", "High Grade" ORDER BY "Count" DESC LIMIT 1	california_schools
SELECT "County Name", COUNT("School Name") AS "School Count" FROM "frpm" JOIN "schools" ON "frpm"."CDSCode" = "schools"."CDSCode" WHERE "County Name" IN ('San Diego', 'Santa Barbara') AND "Physical Building" = 'N' GROUP BY "County Name";	california_schools
SELECT "School Name", "Latitude", "School Type" FROM "schools" ORDER BY "Latitude" DESC LIMIT 1	california_schools
SELECT "City", "School Name", "Low Grade" FROM "schools" WHERE "State" = 'California' ORDER BY "Latitude" ASC LIMIT 1	california_schools
SELECT "Low Grade", "High Grade" FROM "frpm" WHERE "School Code" = (SELECT "School Code" FROM "schools" ORDER BY "Longitude" DESC LIMIT 1)	california_schools
SELECT "City", COUNT("School") AS "SchoolCount" FROM schools WHERE "Magnet" = 1 AND "OpenDate" IS NOT NULL AND "ClosedDate" IS NULL AND "School" IN (SELECT "School Name" FROM frpm WHERE "Low Grade" = 'K' AND "High Grade" = '8') GROUP BY "City";	california_schools
SELECT "AdmFName1", "District Name" FROM "frpm" JOIN "schools" ON "frpm"."CDSCode" = "schools"."CDSCode" GROUP BY "AdmFName1", "District Name" ORDER BY COUNT("AdmFName1") DESC LIMIT 2;	california_schools
SELECT "frpm"."District Code", "frpm"."Percent (%) Eligible Free (K-12)" FROM "frpm" JOIN "schools" ON "frpm"."CDSCode" = "schools"."CDSCode" WHERE "schools"."AdmFName1" = 'Alusine'	california_schools
SELECT "AdmLName1", "District", "County", "School" FROM "schools" JOIN "frpm" ON "schools"."CDSCode" = "frpm"."CDSCode" WHERE "CharterNum" = '40';	california_schools
SELECT "AdmEmail1", "AdmEmail2", "AdmEmail3" FROM "schools" WHERE "County" = 'San Bernardino' AND "City" = 'San Bernardino' AND "OpenDate" BETWEEN '2009-01-01' AND '2010-12-31' AND ("School Type" = 'Public Intermediate/Middle Schools' OR "School Type" = 'Unified Schools');	california_schools
SELECT "sname", "AdmEmail1" FROM "satscores" JOIN "schools" ON "satscores"."cds" = "schools"."CDSCode" WHERE "NumGE1500" > 0 ORDER BY "NumTstTakr" DESC LIMIT 1;	california_schools
SELECT COUNT(DISTINCT "account"."account_id") FROM "account" JOIN "disp" ON "account"."account_id" = "disp"."account_id" JOIN "client" ON "disp"."client_id" = "client"."client_id" JOIN "district" ON "client"."district_id" = "district"."district_id" JOIN "trans" ON "account"."account_id" = "trans"."account_id" WHERE "district"."A2" = 'East Bohemia' AND "disp"."type" = 'issuance' AND "trans"."type" = 'after';	financial
SELECT COUNT(DISTINCT "account"."account_id") FROM "account" JOIN "client" ON "account"."account_id" = "client"."district_id" JOIN "district" ON "client"."district_id" = "district"."district_id" JOIN "loan" ON "account"."account_id" = "loan"."account_id" WHERE "district"."A2" = 'Prague';	financial
SELECT "A2", "A3" FROM district WHERE "A2" = '1995' OR "A2" = '1996';	financial
SELECT COUNT(DISTINCT "district_id") FROM "district" WHERE "A12" > 6000 AND "A12" < 10000;	financial
SELECT COUNT(DISTINCT "client"."client_id") AS "male_customers_count" FROM "client" JOIN "district" ON "client"."district_id" = "district"."district_id" WHERE "client"."gender" = 'male' AND "district"."A2" = 'North Bohemia' AND "district"."A10" > 8000;	financial
SELECT "disp"."account_id" FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" WHERE "client"."gender" = 'female' AND "client"."birth_date" = (SELECT MIN("birth_date") FROM "client" WHERE "gender" = 'female') AND "disp"."account_id" IN (SELECT "account_id" FROM "loan" GROUP BY "account_id" HAVING AVG("amount") = (SELECT MIN(avg_salary) FROM (SELECT AVG("amount") AS avg_salary FROM "loan" GROUP BY "account_id"))) ;	financial
SELECT "disp"."account_id" FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" WHERE "client"."birth_date" = (SELECT MIN("birth_date") FROM "client") AND "client"."district_id" = (SELECT "district_id" FROM "district" ORDER BY "A10" DESC LIMIT 1);	financial
SELECT COUNT(DISTINCT "client_id") FROM "client" c JOIN "disp" d ON c."client_id" = d."client_id" JOIN "account" a ON d."account_id" = a."account_id" WHERE a."frequency" = 'weekly' AND d."type" = 'Owner';	financial
SELECT DISTINCT "client_id" FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "trans" ON "disp"."account_id" = "trans"."account_id" WHERE "trans"."operation" = 'Disponent';	financial
SELECT "account"."account_id", MIN("loan"."amount") AS "lowest_approved_amount" FROM "loan" JOIN "account" ON "loan"."account_id" = "account"."account_id" WHERE "loan"."date" BETWEEN '1997-01-01' AND '1997-12-31' AND "account"."frequency" = 'weekly' GROUP BY "account"."account_id";	financial
SELECT "account"."account_id", MAX("loan"."amount") AS "max_amount" FROM "account" JOIN "loan" ON "account"."account_id" = "loan"."account_id" WHERE "loan"."duration" > 12 AND strftime('%Y', "account"."date") = '1993' GROUP BY "account"."account_id" ORDER BY "max_amount" DESC LIMIT 1;	financial
SELECT COUNT(DISTINCT "client"."client_id") AS "female_customers_count" FROM "client" JOIN "district" ON "client"."district_id" = "district"."district_id" WHERE "client"."gender" = 'female' AND "client"."birth_date" < '1950-01-01' AND "district"."A2" = 'Sokolov';	financial
SELECT "account_id" FROM "trans" WHERE "date" = (SELECT MIN("date") FROM "trans" WHERE "date" BETWEEN '1995-01-01' AND '1995-12-31')	financial
SELECT DISTINCT "account"."account_id" FROM "account" JOIN "loan" ON "account"."account_id" = "loan"."account_id" WHERE "account"."date" < '1997-01-01' AND "loan"."amount" > 3000	financial
SELECT "client_id" FROM "client" INNER JOIN "disp" ON "client"."client_id" = "disp"."client_id" INNER JOIN "card" ON "disp"."disp_id" = "card"."disp_id" WHERE "card"."issued" = '1994-03-03';	financial
SELECT "date" FROM "account" WHERE "account_id" IN (SELECT "account_id" FROM "trans" WHERE "amount" = 840 AND "date" = '1998-10-14')	financial
SELECT "district_id" FROM "account" WHERE "account_id" IN (SELECT "account_id" FROM "loan" WHERE "date" = '1994-08-25')	financial
SELECT MAX("amount") FROM "trans" JOIN "disp" ON "trans"."account_id" = "disp"."account_id" JOIN "card" ON "disp"."disp_id" = "card"."disp_id" WHERE "card"."issued" = '1996-10-21';	financial
SELECT "client"."gender" FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "account" ON "disp"."account_id" = "account"."account_id" JOIN "district" ON "client"."district_id" = "district"."district_id" WHERE "client"."birth_date" = (SELECT MIN("birth_date") FROM "client") AND "district"."A10" = (SELECT MAX("A10") FROM "district");	financial
SELECT "trans"."amount" FROM "trans" JOIN "loan" ON "trans"."account_id" = "loan"."account_id" JOIN "disp" ON "loan"."account_id" = "disp"."account_id" JOIN "client" ON "disp"."client_id" = "client"."client_id" WHERE "loan"."amount" = (SELECT MAX("amount") FROM "loan") AND "trans"."date" = (SELECT MIN("date") FROM "trans" WHERE "trans"."account_id" = "loan"."account_id");	financial
SELECT COUNT(DISTINCT "client_id") FROM "client" JOIN "district" ON "client"."district_id" = "district"."district_id" JOIN "disp" ON "client"."client_id" = "disp"."client_id" WHERE "district"."A2" = 'Jesenik' AND "client"."gender" = 'Female';	financial
SELECT "disp"."disp_id" FROM "trans" JOIN "disp" ON "trans"."account_id" = "disp"."account_id" WHERE "trans"."amount" = 5100 AND "trans"."date" = '1998-09-02';	financial
SELECT COUNT("account"."account_id") FROM "account" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "district"."A2" = 'Litomerice' AND strftime('%Y', "account"."date") = '1996';	financial
SELECT "district"."A2" FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "account" ON "disp"."account_id" = "account"."account_id" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "client"."gender" = 'female' AND "client"."birth_date" = '1976-01-29';	financial
SELECT "birth_date" FROM "client" WHERE "client_id" IN (SELECT "client_id" FROM "loan" WHERE "amount" = 98832 AND "date" = '1996-01-03');	financial
SELECT "account_id" FROM "disp" d JOIN "client" c ON d."client_id" = c."client_id" JOIN "district" di ON c."district_id" = di."district_id" WHERE di."A2" = 'Prague' ORDER BY d."account_id" LIMIT 1	financial
SELECT (SUM(CASE WHEN "gender" = 'male' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS "male_percentage" FROM "client" WHERE "district_id" = (SELECT "district_id" FROM "district" ORDER BY "A8" DESC LIMIT 1);	financial
SELECT "trans_1"."balance" AS "balance_start", "trans_2"."balance" AS "balance_end" FROM "loan" JOIN "trans" AS "trans_1" ON "loan"."account_id" = "trans_1"."account_id" JOIN "trans" AS "trans_2" ON "loan"."account_id" = "trans_2"."account_id" WHERE "loan"."date" = (SELECT MIN("date") FROM "loan" WHERE "date" >= '1993-07-05') AND "trans_1"."date" = '1993-03-22' AND "trans_2"."date" = '1998-12-27';	financial
SELECT (SUM("amount") * 100.0 / (SELECT SUM("amount") FROM "loan")) AS "percentage_fully_paid" FROM "loan" WHERE "status" = 'fully paid';	financial
SELECT (COUNT(CASE WHEN "status" = 'running' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM "loan" WHERE "amount" < 100000;	financial
SELECT "account"."account_id", "district"."A2", "district"."A3" FROM "account" JOIN "district" ON "account"."district_id" = "district"."district_id" JOIN "trans" ON "account"."account_id" = "trans"."account_id" WHERE strftime('%Y', "account"."date") = '1993' AND "trans"."date" > "account"."date";	financial
SELECT "account"."account_id", "account"."frequency" FROM "account" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "district"."A2" = 'east Bohemia' AND "account"."date" BETWEEN '1995-01-01' AND '2000-12-31';	financial
SELECT "account_id", "date" FROM "account" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "district"."A2" = 'Prachatice';	financial
SELECT "district"."A2", "district"."A3" FROM "loan" JOIN "account" ON "loan"."account_id" = "account"."account_id" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "loan"."loan_id" = 4990;	financial
SELECT "loan"."account_id", "district"."A2" AS "district", "district"."A3" AS "region" FROM "loan" JOIN "account" ON "loan"."account_id" = "account"."account_id" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "loan"."amount" > 300000;	financial
SELECT "loan"."loan_id", "district"."district_id", AVG("district"."A10") AS "average_salary" FROM "loan" JOIN "account" ON "loan"."account_id" = "account"."account_id" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "loan"."duration" = 60 GROUP BY "loan"."loan_id", "district"."district_id";	financial
SELECT "district"."A2", "district"."A3" FROM "loan" JOIN "account" ON "loan"."account_id" = "account"."account_id" JOIN "client" ON "account"."account_id" = "client"."client_id" JOIN "district" ON "client"."district_id" = "district"."district_id" WHERE "loan"."status" = 'running' AND "loan"."amount" > 0;	financial
SELECT (COUNT("account"."account_id") * 100.0 / (SELECT COUNT("account"."account_id") FROM "account" WHERE strftime('%Y', "date") = '1993')) AS "percentage" FROM "account" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "district"."A2" = 'Decin' AND strftime('%Y', "account"."date") = '1993';	financial
SELECT "account_id" FROM "account" WHERE "frequency" = 'monthly';	financial
SELECT "district"."district_id", COUNT("client"."client_id") AS "female_count" FROM "district" JOIN "client" ON "district"."district_id" = "client"."district_id" WHERE "client"."gender" = 'female' GROUP BY "district"."district_id" ORDER BY "female_count" DESC LIMIT 9;	financial
SELECT "d"."A2", SUM("t"."amount") AS "total_withdrawals" FROM "trans" AS "t" JOIN "account" AS "a" ON "t"."account_id" = "a"."account_id" JOIN "district" AS "d" ON "a"."district_id" = "d"."district_id" WHERE "t"."type" = 'withdrawal' AND "t"."date" >= '1996-01-01' AND "t"."date" < '1996-02-01' GROUP BY "d"."A2" ORDER BY "total_withdrawals" DESC LIMIT 10;	financial
SELECT COUNT(DISTINCT "disp"."client_id") AS "no_credit_card_count" FROM "client" JOIN "district" ON "client"."district_id" = "district"."district_id" LEFT JOIN "disp" ON "client"."client_id" = "disp"."client_id" LEFT JOIN "card" ON "disp"."disp_id" = "card"."disp_id" WHERE "district"."A2" = 'South Bohemia' AND "card"."card_id" IS NULL;	financial
SELECT "district"."district_id", SUM("loan"."amount") AS "total_loan" FROM "district" JOIN "client" ON "district"."district_id" = "client"."district_id" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "account" ON "disp"."account_id" = "account"."account_id" JOIN "loan" ON "account"."account_id" = "loan"."account_id" WHERE "loan"."status" = 'active' GROUP BY "district"."district_id" ORDER BY "total_loan" DESC LIMIT 1;	financial
SELECT AVG("amount") AS "average_loan_amount" FROM "loan" JOIN "disp" ON "loan"."account_id" = "disp"."account_id" JOIN "client" ON "disp"."client_id" = "client"."client_id" WHERE "client"."gender" = 'male';	financial
SELECT "district"."A2", "district"."A3" FROM "district" WHERE "district"."A8" = (SELECT MAX("A8") FROM "district" WHERE "A4" = 1996);	financial
SELECT COUNT("account_id") FROM "account" WHERE "district_id" = (SELECT "district_id" FROM "trans" WHERE strftime('%Y', "date") = '1996' GROUP BY "district_id" ORDER BY COUNT("trans_id") DESC LIMIT 1);	financial
SELECT COUNT(DISTINCT "account"."account_id") AS "negative_balance_accounts" FROM "account" JOIN "trans" ON "account"."account_id" = "trans"."account_id" WHERE "trans"."type" = 'withdrawal' AND "account"."frequency" = 'monthly' AND "trans"."balance" < 0;	financial
SELECT COUNT("loan_id") FROM "loan" JOIN "account" ON "loan"."account_id" = "account"."account_id" WHERE "loan"."amount" >= 250000 AND "loan"."status" = 'approved' AND "account"."frequency" = 'monthly' AND "loan"."date" BETWEEN '1995-01-01' AND '1997-12-31';	financial
SELECT COUNT(DISTINCT "account"."account_id") FROM "account" JOIN "district" ON "account"."district_id" = "district"."district_id" JOIN "loan" ON "account"."account_id" = "loan"."account_id" WHERE "district"."A2" = 'Branch location 1' AND "loan"."status" = 'running';	financial
SELECT COUNT("client_id") FROM "client" WHERE "gender" = 'male' AND "district_id" = (SELECT "district_id" FROM "district" WHERE "A2" = '1995' ORDER BY "A8" DESC LIMIT 1 OFFSET 1);	financial
SELECT COUNT("card_id") FROM "card" JOIN "disp" ON "card"."disp_id" = "disp"."disp_id" WHERE "disp"."type" = 'OWNER';	financial
SELECT COUNT("account_id") FROM "account" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "district"."A2" = 'Pisek';	financial
SELECT DISTINCT "district"."district_id" FROM "district" JOIN "client" ON "district"."district_id" = "client"."district_id" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "account" ON "disp"."account_id" = "account"."account_id" JOIN "trans" ON "account"."account_id" = "trans"."account_id" WHERE "trans"."date" BETWEEN '1997-01-01' AND '1997-12-31' AND "trans"."amount" > 10000;	financial
SELECT DISTINCT "account"."account_id" FROM "order" JOIN "account" ON "order"."account_id" = "account"."account_id" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "order"."bank_to" = 'household payment' AND "district"."A2" = 'Pisek';	financial
SELECT DISTINCT "account"."account_id" FROM "account" JOIN "disp" ON "account"."account_id" = "disp"."account_id" JOIN "card" ON "disp"."disp_id" = "card"."disp_id" WHERE "card"."type" = 'gold';	financial
SELECT AVG("amount") AS "average_credit_card_amount" FROM "trans" WHERE "date" BETWEEN '2021-01-01' AND '2021-12-31' AND "type" = 'credit_card'	financial
SELECT DISTINCT "disp"."client_id" FROM "trans" JOIN "disp" ON "trans"."account_id" = "disp"."account_id" JOIN "card" ON "disp"."disp_id" = "card"."disp_id" WHERE "trans"."amount" < (SELECT AVG("trans"."amount") FROM "trans" WHERE strftime('%Y', "trans"."date") = '1998') AND strftime('%Y', "card"."issued") = '1998';	financial
SELECT DISTINCT "client"."client_id", "client"."gender" FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "card" ON "disp"."disp_id" = "card"."disp_id" JOIN "loan" ON "disp"."account_id" = "loan"."account_id" WHERE "client"."gender" = 'female';	financial
SELECT COUNT(DISTINCT "account_id") FROM "client" JOIN "district" ON "client"."district_id" = "district"."district_id" WHERE "client"."gender" = 'female' AND "district"."A2" = 'South Bohemia';	financial
SELECT DISTINCT "account"."account_id" FROM "account" JOIN "district" ON "account"."district_id" = "district"."district_id" JOIN "loan" ON "account"."account_id" = "loan"."account_id" WHERE "district"."A2" = 'Tabor';	financial
SELECT DISTINCT "disp"."type" FROM "disp" JOIN "client" ON "disp"."client_id" = "client"."client_id" JOIN "district" ON "client"."district_id" = "district"."district_id" JOIN "account" ON "disp"."account_id" = "account"."account_id" WHERE "account"."frequency" NOT IN ('eligible_for_loan') AND "district"."A10" > 8000 AND "district"."A10" <= 9000;	financial
SELECT COUNT(DISTINCT "account"."account_id") FROM "account" JOIN "district" ON "account"."district_id" = "district"."district_id" JOIN "trans" ON "account"."account_id" = "trans"."account_id" WHERE "district"."A2" = 'North Bohemia' AND "trans"."bank" = 'AB';	financial
SELECT DISTINCT "district"."district_id" FROM "district" JOIN "client" ON "district"."district_id" = "client"."district_id" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "account" ON "disp"."account_id" = "account"."account_id" JOIN "trans" ON "account"."account_id" = "trans"."account_id" WHERE "trans"."type" = 'withdrawal';	financial
SELECT AVG("A8") FROM "district" WHERE "A8" > 4000 AND "district_id" IN (SELECT "district_id" FROM "account" WHERE "date" >= '1997-01-01');	financial
SELECT COUNT(DISTINCT "disp"."account_id") AS eligible_cards FROM "card" JOIN "disp" ON "card"."disp_id" = "disp"."disp_id" JOIN "loan" ON "disp"."account_id" = "loan"."account_id" WHERE "card"."type" = 'classic';	financial
SELECT COUNT("client_id") FROM "client" WHERE "gender" = 'male' AND "district_id" = (SELECT "district_id" FROM "district" WHERE "A2" = 'Hl.m. Praha');	financial
SELECT (COUNT("card_id") * 100.0 / (SELECT COUNT("card_id") FROM "card" WHERE "type" = 'Gold')) AS "percentage" FROM "card" WHERE "type" = 'Gold' AND "issued" < '1998-01-01';	financial
SELECT "client"."client_id", "client"."gender" FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "loan" ON "disp"."account_id" = "loan"."account_id" WHERE "loan"."amount" = (SELECT MAX("amount") FROM "loan");	financial
SELECT COUNT(*) FROM trans WHERE "account_id" = (SELECT "account_id" FROM ACCOUNT WHERE "account_id" = 532) AND strftime('%Y', "date") = '1995';	financial
SELECT "district_id" FROM "district" JOIN "disp" ON "district"."district_id" = "disp"."district_id" JOIN "order" ON "disp"."account_id" = "order"."account_id" WHERE "order"."order_id" = 33333;	financial
SELECT "trans"."date", "trans"."amount" FROM "trans" JOIN "disp" ON "trans"."account_id" = "disp"."account_id" JOIN "client" ON "disp"."client_id" = "client"."client_id" WHERE "client"."client_id" = 3356 AND "trans"."type" = 'withdrawal' AND "trans"."operation" = 'cash';	financial
SELECT COUNT(DISTINCT "account"."account_id") AS "count" FROM "account" JOIN "loan" ON "account"."account_id" = "loan"."account_id" WHERE "account"."frequency" = 'weekly' AND "loan"."amount" < 200000;	financial
SELECT "type" FROM "card" WHERE "disp_id" IN (SELECT "disp_id" FROM "disp" WHERE "client_id" = 13539)	financial
SELECT "district_id" FROM "client" WHERE "client_id" = 3541	financial
SELECT "district"."district_id", COUNT("account"."account_id") AS "account_count" FROM "account" JOIN "loan" ON "account"."account_id" = "loan"."account_id" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "loan"."status" = 'finished' AND "loan"."payments" = 0 GROUP BY "district"."district_id" ORDER BY "account_count" DESC LIMIT 1;	financial
SELECT "client_id" FROM "order" JOIN "disp" ON "order"."account_id" = "disp"."account_id" WHERE "order"."order_id" = 32423	financial
SELECT "trans"."trans_id", "trans"."date", "trans"."type", "trans"."operation", "trans"."amount", "trans"."balance" FROM "trans" JOIN "account" ON "trans"."account_id" = "account"."account_id" WHERE "account"."district_id" = 5;	financial
SELECT COUNT("account_id") FROM "account" WHERE "district_id" = (SELECT "district_id" FROM "district" WHERE "A2" = 'Jesenik');	financial
SELECT DISTINCT "client_id" FROM "client" INNER JOIN "disp" ON "client"."client_id" = "disp"."client_id" INNER JOIN "card" ON "disp"."disp_id" = "card"."disp_id" WHERE "card"."type" = 'junior' AND "card"."issued" > '1996-01-01'	financial
SELECT (COUNT(CASE WHEN "gender" = 'Female' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage_women" FROM "client" WHERE "district_id" IN (SELECT "district_id" FROM "district" WHERE "A10" > 10000);	financial
SELECT SUM("amount") AS total_loans FROM "loan" WHERE "account_id" IN (SELECT "account_id" FROM "disp" WHERE "client_id" IN (SELECT "client_id" FROM "client" WHERE "gender" = 'male')) AND "date" BETWEEN '1996-01-01' AND '1997-12-31';	financial
SELECT COUNT(*) FROM "trans" WHERE "type" = 'withdrawal' AND "date" > '1995-01-01';	financial
SELECT COUNT(*) AS "crime_count", "district"."A2" FROM "district" JOIN "trans" ON "district"."district_id" = "trans"."account_id" WHERE "trans"."date" BETWEEN '1996-01-01' AND '1996-12-31' AND ("district"."A2" = 'East Bohemia' OR "district"."A2" = 'North Bohemia') GROUP BY "district"."A2";	financial
SELECT COUNT(*) AS "disposition_count" FROM "disp" WHERE "account_id" IN (1, 10);	financial
SELECT "frequency", SUM("amount") AS total_debit FROM "account" JOIN "order" ON "account"."account_id" = "order"."account_id" JOIN "trans" ON "account"."account_id" = "trans"."account_id" WHERE "account"."account_id" = 3 GROUP BY "frequency";	financial
SELECT "birth_date" FROM "client" WHERE "client_id" = 130	financial
SELECT COUNT(DISTINCT "account_id") FROM "disp" WHERE "type" = 'owner' AND "account_id" IN (SELECT "account_id" FROM "trans" WHERE "operation" = 'request_statement');	financial
SELECT "loan"."amount", "loan"."payments" FROM "loan" JOIN "disp" ON "loan"."account_id" = "disp"."account_id" JOIN "client" ON "disp"."client_id" = "client"."client_id" WHERE "client"."client_id" = 992;	financial
SELECT SUM("amount") AS total_amount, "client"."gender" FROM "trans" JOIN "disp" ON "trans"."account_id" = "disp"."account_id" JOIN "client" ON "disp"."client_id" = "client"."client_id" WHERE "trans"."trans_id" = 851 AND "client"."client_id" = 4;	financial
SELECT "type" FROM "card" INNER JOIN "disp" ON "card"."disp_id" = "disp"."disp_id" INNER JOIN "client" ON "disp"."client_id" = "client"."client_id" WHERE "client"."client_id" = 9	financial
SELECT SUM("trans"."amount") AS total_paid FROM "trans" JOIN "disp" ON "trans"."account_id" = "disp"."account_id" JOIN "client" ON "disp"."client_id" = "client"."client_id" WHERE "client"."client_id" = 617 AND strftime('%Y', "trans"."date") = '1998';	financial
SELECT "client_id" FROM "client" JOIN "district" ON "client"."district_id" = "district"."district_id" WHERE "birth_date" BETWEEN '1983-01-01' AND '1987-12-31' AND "district"."A2" = 'East Bohemia';	financial
SELECT "client"."client_id" FROM "client" JOIN "loan" ON "client"."client_id" = "loan"."account_id" WHERE "client"."gender" = 'female' ORDER BY "loan"."amount" DESC LIMIT 3;	financial
SELECT COUNT(DISTINCT "client"."client_id") FROM "client" JOIN "loan" ON "client"."client_id" = "loan"."account_id" WHERE "client"."gender" = 'male' AND "client"."birth_date" BETWEEN '1974-01-01' AND '1976-12-31' AND "loan"."payments" > 4000;	financial
SELECT COUNT("account_id") FROM "account" JOIN "district" ON "account"."district_id" = "district"."district_id" WHERE "district"."A2" = 'Beroun' AND "account"."date" > '1996-01-01';	financial
SELECT COUNT(DISTINCT "client"."client_id") FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "card" ON "disp"."disp_id" = "card"."disp_id" WHERE "client"."gender" = 'female' AND "card"."type" = 'junior';	financial
SELECT SUM(CASE WHEN "gender" = 'Female' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS "female_proportion" FROM "client" JOIN "district" ON "client"."district_id" = "district"."district_id" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "account" ON "disp"."account_id" = "account"."account_id" WHERE "district"."A2" = 'Prague';	financial
SELECT (COUNT(CASE WHEN "frequency" = 'weekly' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "account" ON "disp"."account_id" = "account"."account_id" WHERE "client"."gender" = 'male';	financial
SELECT COUNT(DISTINCT "client"."client_id") FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "account" ON "disp"."account_id" = "account"."account_id" WHERE "account"."frequency" = 'weekly' AND "disp"."type" = 'Owner';	financial
SELECT "account"."account_id", MIN("loan"."amount") AS "lowest_approved_amount" FROM "account" JOIN "loan" ON "account"."account_id" = "loan"."account_id" WHERE "loan"."duration" > 24 AND "account"."date" < '1997-01-01' GROUP BY "account"."account_id";	financial
SELECT "disp"."account_id" FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" WHERE "client"."gender" = 'female' ORDER BY "client"."birth_date" ASC LIMIT 1;	financial
SELECT COUNT("client_id") FROM "client" WHERE "birth_date" LIKE '1920%' AND "district_id" IN (SELECT "district_id" FROM "district" WHERE "A2" = 'east Bohemia');	financial
SELECT COUNT("loan_id") FROM "loan" JOIN "account" ON "loan"."account_id" = "account"."account_id" WHERE "loan"."duration" = 24 AND "account"."frequency" = 'weekly';	financial
SELECT AVG("amount") FROM "loan" WHERE "status" = 'running' AND "account_id" IN (SELECT DISTINCT "account_id" FROM "trans");	financial
SELECT DISTINCT "client_id", "district_id" FROM "client" WHERE "client_id" NOT IN (SELECT "client_id" FROM "disp" WHERE "type" = 'temporary') AND "client_id" NOT IN (SELECT "client_id" FROM "loan");	financial
SELECT "client"."client_id", (strftime('%Y', 'now') - strftime('%Y', "client"."birth_date")) AS "age" FROM "client" JOIN "disp" ON "client"."client_id" = "disp"."client_id" JOIN "card" ON "disp"."disp_id" = "card"."disp_id" WHERE "card"."type" = 'high level' AND "client"."client_id" IN (SELECT "loan"."account_id" FROM "loan");	financial
SELECT "bond_type", COUNT(*) AS "count" FROM "bond" GROUP BY "bond_type" ORDER BY "count" DESC LIMIT 1	toxicology
SELECT COUNT(DISTINCT "molecule"."molecule_id") FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "atom"."element" = 'Cl' AND "molecule"."label" NOT LIKE '%carcinogen%';	toxicology
SELECT AVG(oxygen_count) AS average_oxygen_count FROM (SELECT COUNT("atom"."atom_id") AS oxygen_count FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "atom"."element" = 'O' AND "bond"."bond_type" = 'single' GROUP BY "molecule"."molecule_id");	toxicology
SELECT AVG(CASE WHEN "bond_type" = 'single' THEN 1 ELSE 0 END) AS average_single_bonded_carcinogenic FROM "bond" JOIN "molecule" ON "bond"."molecule_id" = "molecule"."molecule_id" WHERE "molecule"."label" LIKE '%carcinogenic%';	toxicology
SELECT COUNT(DISTINCT "atom"."atom_id") AS "non_carcinogenic_sodium_atoms" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "atom"."element" = 'sodium' AND "molecule"."label" NOT LIKE '%carcinogenic%';	toxicology
SELECT DISTINCT "molecule"."molecule_id", "molecule"."label" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'triple' AND "molecule"."label" LIKE '%carcinogenic%';	toxicology
SELECT (COUNT(CASE WHEN "element" = 'C' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage_of_carbon" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'double';	toxicology
SELECT COUNT("bond_id") FROM "bond" WHERE "bond_type" = 'triple';	toxicology
SELECT COUNT(DISTINCT "atom"."atom_id") AS "no_bromine_atoms" FROM "atom" WHERE "atom"."element" != 'Br';	toxicology
SELECT COUNT(DISTINCT "molecule_id") FROM "molecule" WHERE "molecule_id" IN (SELECT "molecule_id" FROM "molecule" ORDER BY "molecule_id" LIMIT 100) AND "label" LIKE '%carcinogenic%';	toxicology
SELECT DISTINCT "molecule_id" FROM "atom" WHERE "element" = 'carbon'	toxicology
SELECT DISTINCT "a"."element" FROM "atom" AS "a" JOIN "connected" AS "c" ON "a"."atom_id" = "c"."atom_id" JOIN "bond" AS "b" ON "c"."bond_id" = "b"."bond_id" WHERE "b"."bond_id" = 'TR004_8_9';	toxicology
SELECT DISTINCT "a1"."element", "a2"."element" FROM "connected" JOIN "bond" ON "connected"."bond_id" = "bond"."bond_id" JOIN "atom" AS "a1" ON "connected"."atom_id" = "a1"."atom_id" JOIN "atom" AS "a2" ON "connected"."atom_id2" = "a2"."atom_id" WHERE "bond"."bond_type" = 'double';	toxicology
SELECT "molecule"."label", COUNT(*) AS "count" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "atom"."element" = 'hydrogen' GROUP BY "molecule"."label" ORDER BY "count" DESC LIMIT 1;	toxicology
SELECT "bond"."bond_type" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "atom"."element" = 'Chlorine';	toxicology
SELECT "a1"."atom_id", "a2"."atom_id2" FROM "connected" AS "c" JOIN "atom" AS "a1" ON "c"."atom_id" = "a1"."atom_id" JOIN "atom" AS "a2" ON "c"."atom_id2" = "a2"."atom_id" JOIN "bond" AS "b" ON "c"."bond_id" = "b"."bond_id" WHERE "b"."bond_type" = 'single';	toxicology
SELECT DISTINCT "atom"."atom_id", "connected"."atom_id2" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" JOIN "connected" ON "bond"."bond_id" = "connected"."bond_id" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "molecule"."label" NOT LIKE '%carcinogenic%';	toxicology
SELECT "element", COUNT("element") AS "element_count" FROM "atom" WHERE "molecule_id" IN (SELECT "molecule_id" FROM "molecule" WHERE "label" NOT LIKE '%carcinogenic%') GROUP BY "element" ORDER BY "element_count" ASC LIMIT 1;	toxicology
SELECT "bond"."bond_type" FROM "connected" JOIN "bond" ON "connected"."bond_id" = "bond"."bond_id" WHERE ("connected"."atom_id" = 'TR004_8' AND "connected"."atom_id2" = 'TR004_20') OR ("connected"."atom_id" = 'TR004_20' AND "connected"."atom_id2" = 'TR004_8');	toxicology
SELECT DISTINCT "label" FROM "molecule" WHERE "molecule_id" NOT IN (SELECT DISTINCT "molecule_id" FROM "atom" WHERE "element" = 'Sn')	toxicology
SELECT COUNT(DISTINCT "atom"."atom_id") AS "atom_count" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'single' AND ("atom"."element" = 'iodine' OR "atom"."element" = 'sulfur');	toxicology
SELECT "connected"."atom_id", "connected"."atom_id2" FROM "connected" JOIN "bond" ON "connected"."bond_id" = "bond"."bond_id" WHERE "bond"."bond_type" = 'triple';	toxicology
SELECT "atom"."atom_id" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" JOIN "connected" ON "atom"."atom_id" = "connected"."atom_id" WHERE "molecule"."label" = 'TR181'	toxicology
SELECT (COUNT(DISTINCT "molecule"."molecule_id") * 100.0 / (SELECT COUNT(DISTINCT "molecule"."molecule_id") FROM "molecule" WHERE "molecule"."label" LIKE '%carcinogenic%')) AS "percentage" FROM "molecule" LEFT JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "molecule"."label" LIKE '%carcinogenic%' AND "atom"."element" != 'F';	toxicology
SELECT (COUNT(DISTINCT m."molecule_id") * 100.0 / (SELECT COUNT(DISTINCT "molecule_id") FROM bond WHERE "bond_type" = 'triple')) AS "percentage" FROM bond b JOIN molecule m ON b."molecule_id" = m."molecule_id" WHERE b."bond_type" = 'triple' AND m."label" LIKE '%carcinogenic%';	toxicology
SELECT DISTINCT "element" FROM "atom" WHERE "molecule_id" = 'TR000' ORDER BY "element" LIMIT 3;	toxicology
SELECT "atom"."atom_id" FROM "connected" JOIN "atom" ON "connected"."atom_id" = "atom"."atom_id" WHERE "connected"."bond_id" = 'TR001_2_6' AND "connected"."atom_id" IN (SELECT "atom_id" FROM "connected" WHERE "bond_id" = 'TR001_2_6')	toxicology
SELECT SUM(CASE WHEN "bond_type" = 'carcinogenic' THEN 1 ELSE 0 END) AS "carcinogenic_count", SUM(CASE WHEN "bond_type" != 'carcinogenic' THEN 1 ELSE 0 END) AS "non_carcinogenic_count" FROM "bond";	toxicology
SELECT "atom_id", "atom_id2" FROM "connected" WHERE "bond_id" = 'TR000_2_5'	toxicology
SELECT "bond_id" FROM "connected" WHERE "atom_id2" = 'TR000_2'	toxicology
SELECT DISTINCT "molecule"."label" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'double' ORDER BY "molecule"."label" LIMIT 5;	toxicology
SELECT (COUNT(CASE WHEN "bond_type" = 'double' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage_double_bonds" FROM "bond" WHERE "molecule_id" = 'TR008';	toxicology
SELECT (COUNT(CASE WHEN "label" LIKE '%carcinogenic%' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM "molecule";	toxicology
SELECT (SUM(CASE WHEN "element" = 'H' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS "percentage_hydrogen" FROM "atom" WHERE "molecule_id" = 'TR206';	toxicology
SELECT "bond"."bond_type" FROM "bond" WHERE "bond"."molecule_id" = 'TR000'	toxicology
SELECT "atom"."element", "molecule"."label" FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "molecule"."label" = 'TR060';	toxicology
SELECT "bond"."bond_type", COUNT("bond"."bond_id") AS "bond_count", (SELECT COUNT(*) FROM "molecule" WHERE "molecule_id" = 'TR010' AND "label" LIKE '%carcinogenic%') AS "is_carcinogenic" FROM "bond" WHERE "bond"."molecule_id" = 'TR010' GROUP BY "bond"."bond_type" ORDER BY "bond_count" DESC LIMIT 1;	toxicology
SELECT DISTINCT "molecule"."label" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'single' AND "molecule"."label" NOT LIKE '%carcinogenic%' ORDER BY "molecule"."label" LIMIT 3;	toxicology
SELECT "bond_id" FROM "bond" WHERE "molecule_id" = 'TR006' ORDER BY "bond_id" ASC LIMIT 2;	toxicology
SELECT COUNT("bond_id") FROM "bond" WHERE "molecule_id" = 'TR009' AND ("bond_id" IN (SELECT "bond_id" FROM "connected" WHERE "atom_id" = '12' OR "atom_id2" = '12'));	toxicology
SELECT COUNT(DISTINCT "molecule"."molecule_id") FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "atom"."element" = 'bromine' AND "molecule"."label" LIKE '%carcinogenic%'	toxicology
SELECT "bond"."bond_type", "connected"."atom_id", "connected"."atom_id2" FROM "bond" JOIN "connected" ON "bond"."bond_id" = "connected"."bond_id" WHERE "bond"."bond_id" = 'TR001_6_9';	toxicology
SELECT "molecule"."label", "molecule"."molecule_id" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "atom"."atom_id" = 'TR001_10';	toxicology
SELECT COUNT(DISTINCT "molecule_id") FROM "bond" WHERE "bond_type" = 'triple';	toxicology
SELECT COUNT(*) AS "connection_count" FROM "connected" WHERE "atom_id" = '19'	toxicology
SELECT "atom"."element" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "molecule"."label" = 'TR004'	toxicology
SELECT COUNT(DISTINCT "molecule"."molecule_id") AS "non_carcinogenic_molecules" FROM "molecule" LEFT JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" IS NULL;	toxicology
SELECT DISTINCT "molecule"."label" FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "atom"."atom_id" BETWEEN '21' AND '25' AND "molecule"."label" LIKE '%carcinogenic%'	toxicology
SELECT DISTINCT "bond"."bond_id", "bond"."bond_type" FROM "bond" JOIN "atom" AS "a1" ON "bond"."molecule_id" = "a1"."molecule_id" JOIN "atom" AS "a2" ON "bond"."molecule_id" = "a2"."molecule_id" WHERE "a1"."element" = 'phosphorus' AND "a2"."element" = 'nitrogen';	toxicology
SELECT "molecule"."label", COUNT("bond"."bond_id") AS "double_bond_count" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'double' GROUP BY "molecule"."molecule_id" ORDER BY "double_bond_count" DESC LIMIT 1;	toxicology
SELECT AVG(bond_count) AS average_bonds FROM (SELECT "atom"."atom_id", COUNT("bond"."bond_id") AS bond_count FROM "atom" LEFT JOIN "connected" ON "atom"."atom_id" = "connected"."atom_id" LEFT JOIN "bond" ON "connected"."bond_id" = "bond"."bond_id" WHERE "atom"."element" = 'iodine' GROUP BY "atom"."atom_id");	toxicology
SELECT "bond"."bond_type", "bond"."bond_id" FROM "bond" JOIN "connected" ON "bond"."bond_id" = "connected"."bond_id" WHERE "connected"."atom_id" = '45' OR "connected"."atom_id2" = '45';	toxicology
SELECT DISTINCT "element" FROM "atom" WHERE "atom_id" NOT IN (SELECT "atom_id" FROM "connected")	toxicology
SELECT "atom"."atom_id" FROM "atom" JOIN "bond" ON "atom"."molecule_id" = "bond"."molecule_id" WHERE "bond"."molecule_id" = 'TR041' AND "bond"."bond_type" = 'triple';	toxicology
SELECT "element" FROM "atom" WHERE "molecule_id" = 'TR144_8_19'	toxicology
SELECT "molecule"."label", COUNT("bond"."bond_id") AS "double_bond_count" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'double' GROUP BY "molecule"."label" ORDER BY "double_bond_count" DESC LIMIT 1;	toxicology
SELECT "element", COUNT(*) AS "count" FROM "atom" WHERE "molecule_id" IN (SELECT "molecule_id" FROM "bond" WHERE "bond_type" = 'carcinogenic') GROUP BY "element" ORDER BY "count" ASC LIMIT 1;	toxicology
SELECT "a2"."element" FROM "atom" AS "a1" JOIN "connected" AS "c" ON "a1"."atom_id" = "c"."atom_id" JOIN "atom" AS "a2" ON "c"."atom_id2" = "a2"."atom_id" WHERE "a1"."element" = 'lead';	toxicology
SELECT DISTINCT "a"."element" FROM "atom" AS "a" JOIN "connected" AS "c" ON "a"."atom_id" = "c"."atom_id" JOIN "bond" AS "b" ON "c"."bond_id" = "b"."bond_id" WHERE "b"."bond_type" = 'triple';	toxicology
SELECT COUNT(DISTINCT "bond"."bond_id") * 100.0 / (SELECT COUNT(*) FROM "bond") AS "percentage" FROM "bond" JOIN "connected" ON "bond"."bond_id" = "connected"."bond_id" JOIN "atom" AS "a1" ON "connected"."atom_id" = "a1"."atom_id" JOIN "atom" AS "a2" ON "connected"."atom_id2" = "a2"."atom_id" WHERE ("a1"."element", "a2"."element") IN (SELECT "a1"."element", "a2"."element" FROM "connected" JOIN "atom" AS "a1" ON "connected"."atom_id" = "a1"."atom_id" JOIN "atom" AS "a2" ON "connected"."atom_id2" = "a2"."atom_id" GROUP BY "a1"."element", "a2"."element" ORDER BY COUNT(*) DESC LIMIT 1);	toxicology
SELECT (SUM(CASE WHEN "bond_type" = 'single' AND "is_carcinogenic" = 1 THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN "bond_type" = 'single' THEN 1 ELSE 0 END), 0)) AS "proportion_carcinogenic" FROM bond JOIN (SELECT DISTINCT "bond_id", 1 AS "is_carcinogenic" FROM connected WHERE "bond_id" IS NOT NULL) AS carcinogenic_bonds ON bond.bond_id = carcinogenic_bonds.bond_id;	toxicology
SELECT COUNT(*) FROM "atom" WHERE "element" IN ('carbon', 'hydrogen');	toxicology
SELECT DISTINCT "atom_id2" FROM "connected" JOIN "atom" ON "connected"."atom_id" = "atom"."atom_id" WHERE "atom"."element" = 'sulfur'	toxicology
SELECT DISTINCT "bond"."bond_type" FROM "bond" JOIN "molecule" ON "bond"."molecule_id" = "molecule"."molecule_id" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "atom"."element" = 'Tin';	toxicology
SELECT COUNT(DISTINCT "atom"."element") AS "element_count" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" JOIN "connected" ON "bond"."bond_id" = "connected"."bond_id" JOIN "atom" ON "connected"."atom_id" = "atom"."atom_id" WHERE "bond"."bond_type" = 'single';	toxicology
SELECT COUNT(DISTINCT "atom"."atom_id") AS total_atoms FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'triple' AND ("atom"."element" = 'phosphorus' OR "atom"."element" = 'bromine');	toxicology
SELECT DISTINCT "bond"."bond_id" FROM "bond" JOIN "molecule" ON "bond"."molecule_id" = "molecule"."molecule_id" WHERE "molecule"."label" LIKE '%carcinogenic%'	toxicology
SELECT DISTINCT "molecule"."molecule_id" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'single' AND "molecule"."molecule_id" NOT IN (SELECT "molecule_id" FROM "atom" WHERE "element" = 'carcinogenic');	toxicology
SELECT COUNT("atom"."atom_id") * 100.0 / (SELECT COUNT("atom"."atom_id") FROM "atom" JOIN "bond" ON "atom"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'single') AS "chlorine_percentage" FROM "atom" WHERE "atom"."element" = 'chlorine';	toxicology
SELECT "label" FROM "molecule" WHERE "molecule_id" IN ('TR000', 'TR001', 'TR002')	toxicology
SELECT DISTINCT "molecule_id" FROM "molecule" WHERE "label" NOT LIKE '%carcinogenic%'	toxicology
SELECT COUNT(DISTINCT "molecule_id") AS "total_carcinogenic_molecules" FROM "molecule" WHERE "molecule_id" BETWEEN 'TR000' AND 'TR030';	toxicology
SELECT DISTINCT "bond"."bond_type" FROM "bond" WHERE "bond"."molecule_id" BETWEEN 'TR000' AND 'TR050';	toxicology
SELECT "a"."element" FROM "atom" AS "a" JOIN "connected" AS "c" ON "a"."atom_id" = "c"."atom_id" WHERE "c"."bond_id" = 'TR001_10_11';	toxicology
SELECT COUNT(DISTINCT "bond"."bond_id") FROM "bond" JOIN "atom" ON "bond"."molecule_id" = "atom"."molecule_id" WHERE "atom"."element" = 'iodine';	toxicology
SELECT COUNT(DISTINCT "molecule"."molecule_id") AS "total_molecules", SUM(CASE WHEN "bond"."bond_type" = 'carcinogenic' THEN 1 ELSE 0 END) AS "carcinogenic_count" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "atom"."element" = 'Calcium';	toxicology
SELECT COUNT(DISTINCT "element") AS element_count FROM "atom" JOIN "connected" ON "atom"."atom_id" = "connected"."atom_id" JOIN "bond" ON "connected"."bond_id" = "bond"."bond_id" WHERE "bond"."bond_id" = 'TR001_1_8' AND "element" IN ('chlorine', 'carbon');	toxicology
SELECT DISTINCT "molecule_id" FROM "bond" JOIN "atom" ON "bond"."molecule_id" = "atom"."molecule_id" WHERE "bond"."bond_type" = 'triple' AND "atom"."element" = 'carbon' AND "molecule_id" NOT IN (SELECT "molecule_id" FROM "toxicology" WHERE "carcinogenic" = 1) LIMIT 2;	toxicology
SELECT (COUNT(CASE WHEN "element" = 'Cl' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "molecule"."label" LIKE '%carcinogenic%';	toxicology
SELECT DISTINCT "atom"."element" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "molecule"."molecule_id" = 'TR001';	toxicology
SELECT DISTINCT "molecule_id" FROM "bond" WHERE "bond_type" = 'double'	toxicology
SELECT "connected"."atom_id", "connected"."atom_id2" FROM "connected" JOIN "bond" ON "connected"."bond_id" = "bond"."bond_id" WHERE "bond"."bond_type" = 'triple';	toxicology
SELECT DISTINCT "atom"."element" FROM "connected" JOIN "atom" ON "connected"."atom_id" = "atom"."atom_id" WHERE "connected"."bond_id" = 'TR000_1_2'	toxicology
SELECT COUNT(DISTINCT "molecule"."molecule_id") AS "non_carcinogenic_single_bonds" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'single' AND "molecule"."label" NOT LIKE '%carcinogenic%';	toxicology
SELECT "label" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_id" = 'TR001_10_11'	toxicology
SELECT "bond"."bond_id", "molecule"."label" FROM "bond" JOIN "molecule" ON "bond"."molecule_id" = "molecule"."molecule_id" WHERE "bond"."bond_type" = 'triple';	toxicology
SELECT COUNT("element") FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "molecule"."label" = 'carcinogenic' GROUP BY "molecule"."molecule_id" HAVING COUNT("atom"."atom_id") >= 4;	toxicology
SELECT "label", (SELECT COUNT(*) FROM atom WHERE "molecule_id" = 'TR006' AND "element" = 'Hydrogen') * 1.0 / (SELECT COUNT(*) FROM atom WHERE "molecule_id" = 'TR006') AS "Hydrogen_ratio" FROM molecule WHERE "molecule_id" = 'TR006';	toxicology
SELECT "molecule"."label" FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "atom"."element" = 'Calcium';	toxicology
SELECT DISTINCT "bond"."bond_type" FROM "bond" JOIN "molecule" ON "bond"."molecule_id" = "molecule"."molecule_id" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "atom"."element" = 'Carbon';	toxicology
SELECT DISTINCT "a1"."element", "a2"."element" FROM "connected" "c" JOIN "atom" "a1" ON "c"."atom_id" = "a1"."atom_id" JOIN "atom" "a2" ON "c"."atom_id2" = "a2"."atom_id" JOIN "bond" "b" ON "c"."bond_id" = "b"."bond_id" WHERE "b"."bond_id" = 'TR001_10_11';	toxicology
SELECT (COUNT(DISTINCT "molecule_id") * 100.0 / (SELECT COUNT(DISTINCT "molecule_id") FROM "molecule")) AS "percent_triple_bond" FROM "bond" WHERE "bond_type" = 'triple';	toxicology
SELECT (COUNT(CASE WHEN "bond_type" = 'double' THEN 1 END) * 100.0 / COUNT(*)) AS "percent_double_bond" FROM "bond" WHERE "molecule_id" = 'TR047';	toxicology
SELECT "molecule"."label" FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "atom"."atom_id" = 'TR001_1';	toxicology
SELECT "molecule"."label" FROM "molecule" WHERE "molecule"."molecule_id" = 'TR151'	toxicology
SELECT "element" FROM "atom" WHERE "molecule_id" = 'TR151';	toxicology
SELECT COUNT(DISTINCT "molecule_id") FROM "molecule" WHERE "label" LIKE '%carcinogenic%'	toxicology
SELECT "atom"."atom_id" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "molecule"."molecule_id" BETWEEN 'TR010' AND 'TR050' AND "atom"."element" = 'carbon';	toxicology
SELECT COUNT(DISTINCT "atom"."atom_id") FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "molecule"."label" LIKE '%carcinogenic%';	toxicology
SELECT DISTINCT "bond"."bond_id" FROM "bond" JOIN "molecule" ON "bond"."molecule_id" = "molecule"."molecule_id" WHERE "bond"."bond_type" = 'double' AND "molecule"."label" LIKE '%carcinogenic%';	toxicology
SELECT COUNT("atom"."atom_id") FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "atom"."element" = 'hydrogen' AND "molecule"."label" LIKE '%carcinogenic%';	toxicology
SELECT "molecule_id" FROM "bond" WHERE "bond_id" IN (SELECT "bond_id" FROM "connected" WHERE "atom_id" = 'TR000_1') AND "molecule_id" IN (SELECT "molecule_id" FROM "atom" WHERE "atom_id" = 'TR000_1_2');	toxicology
SELECT "atom"."atom_id" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "atom"."element" = 'carbon' AND "molecule"."label" != 'carcinogenic';	toxicology
SELECT (COUNT(DISTINCT m."molecule_id") * 100.0 / (SELECT COUNT(DISTINCT "molecule_id") FROM "atom" WHERE "element" = 'hydrogen')) AS "percentage" FROM "atom" a JOIN "molecule" m ON a."molecule_id" = m."molecule_id" WHERE a."element" = 'hydrogen' AND m."label" LIKE '%carcinogenic%';	toxicology
SELECT "label" FROM "molecule" WHERE "molecule_id" = 'TR124'	toxicology
SELECT "atom"."element" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "molecule"."label" = 'TR186'	toxicology
SELECT "bond_type" FROM "bond" WHERE "molecule_id" = 'TR007_4_19'	toxicology
SELECT DISTINCT "element" FROM "atom" JOIN "connected" ON "atom"."atom_id" = "connected"."atom_id" WHERE "connected"."bond_id" = 'TR001_2_4'	toxicology
SELECT COUNT("bond_id") AS "double_bond_count", "molecule"."label" FROM "bond" JOIN "molecule" ON "bond"."molecule_id" = "molecule"."molecule_id" WHERE "bond"."bond_type" = 'double' AND "molecule"."label" = 'TR006' GROUP BY "molecule"."label";	toxicology
SELECT "molecule"."label", "atom"."element" FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "molecule"."label" LIKE '%carcinogen%';	toxicology
SELECT "bond"."bond_id", "bond"."bond_type", "connected"."atom_id", "connected"."atom_id2" FROM "bond" JOIN "connected" ON "bond"."bond_id" = "connected"."bond_id" WHERE "bond"."bond_type" = 'single';	toxicology
SELECT DISTINCT "molecule"."label", "atom"."element" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" JOIN "connected" ON "bond"."bond_id" = "connected"."bond_id" JOIN "atom" ON "connected"."atom_id" = "atom"."atom_id" WHERE "bond"."bond_type" = 'triple';	toxicology
SELECT DISTINCT "a"."element" FROM "atom" AS "a" JOIN "connected" AS "c" ON "a"."atom_id" = "c"."atom_id" WHERE "c"."bond_id" = 'TR000_2_3' OR "a"."atom_id" = "c"."atom_id2";	toxicology
SELECT COUNT(DISTINCT "bond"."bond_id") AS "bond_count" FROM "bond" JOIN "atom" ON "bond"."molecule_id" = "atom"."molecule_id" WHERE "atom"."element" = 'chlorine';	toxicology
SELECT "atom"."atom_id", COUNT("bond"."bond_type") AS "bond_count" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "molecule"."label" = 'TR346' GROUP BY "atom"."atom_id";	toxicology
SELECT COUNT(DISTINCT "molecule"."molecule_id") AS "double_bond_count" FROM "bond" JOIN "molecule" ON "bond"."molecule_id" = "molecule"."molecule_id" WHERE "bond"."bond_type" = 'double' AND "molecule"."label" = 'carcinogenic compound';	toxicology
SELECT COUNT(DISTINCT "molecule"."molecule_id") FROM "molecule" LEFT JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" LEFT JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "atom"."element" != 'sulphur' AND ("bond"."bond_type" IS NULL OR "bond"."bond_type" != 'double');	toxicology
SELECT "label" FROM "molecule" WHERE "molecule_id" IN (SELECT "molecule_id" FROM "bond" WHERE "bond_id" = 'TR001_2_4')	toxicology
SELECT COUNT("atom"."atom_id") FROM "atom" WHERE "atom"."molecule_id" = 'TR001'	toxicology
SELECT COUNT(*) FROM "bond" WHERE "bond_type" = 'single';	toxicology
SELECT DISTINCT "molecule"."molecule_id", "molecule"."label" FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "atom"."element" = 'cl' AND "molecule"."label" LIKE '%carcinogenic%';	toxicology
SELECT DISTINCT "molecule"."molecule_id", "molecule"."label" FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "atom"."element" = 'c' AND "molecule"."molecule_id" NOT IN (SELECT "molecule_id" FROM "bond" WHERE "bond_type" = 'carcinogenic');	toxicology
SELECT (COUNT(DISTINCT m."molecule_id") * 100.0 / (SELECT COUNT(DISTINCT "molecule_id") FROM molecule)) AS "percentage" FROM molecule m JOIN atom a ON m."molecule_id" = a."molecule_id" WHERE a."element" = 'Chlorine' AND m."label" LIKE '%carcinogenic%';	toxicology
SELECT "molecule_id" FROM "bond" WHERE "bond_id" = 'TR001_1_7'	toxicology
SELECT COUNT(DISTINCT "atom_id") FROM "connected" WHERE "bond_id" = 'TR001_3_4'	toxicology
SELECT "bond"."bond_type" FROM "connected" JOIN "bond" ON "connected"."bond_id" = "bond"."bond_id" WHERE "connected"."atom_id" = 'TR000_1' AND "connected"."atom_id2" = 'TR000_2';	toxicology
SELECT DISTINCT "molecule"."label" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "atom"."atom_id" IN ("TR000_2", "TR000_4");	toxicology
SELECT "element" FROM "atom" WHERE "atom_id" = 'TR000_1'	toxicology
SELECT "label" FROM "molecule" WHERE "molecule_id" = 'TR000'	toxicology
SELECT (COUNT(CASE WHEN "bond_type" = 'single' THEN 1 END) * 100.0 / COUNT(DISTINCT "atom"."atom_id")) AS "percentage_single_bond" FROM "atom" JOIN "connected" ON "atom"."atom_id" = "connected"."atom_id" JOIN "bond" ON "connected"."bond_id" = "bond"."bond_id";	toxicology
SELECT COUNT(DISTINCT "molecule"."molecule_id") FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "atom"."element" = 'Nitrogen' AND "molecule"."label" LIKE '%carcinogenic%';	toxicology
SELECT "molecule"."molecule_id" FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "atom"."element" = 'Sulphur' AND "bond"."bond_type" = 'double';	toxicology
SELECT "molecule"."molecule_id", "molecule"."label" FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" GROUP BY "molecule"."molecule_id" HAVING COUNT("atom"."atom_id") > 5;	toxicology
SELECT DISTINCT "atom"."element" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'double' AND "molecule"."label" = 'TR024';	toxicology
SELECT "molecule"."label", COUNT("atom"."atom_id") AS "atom_count" FROM "molecule" JOIN "atom" ON "molecule"."molecule_id" = "atom"."molecule_id" WHERE "molecule"."label" LIKE '%carcinogenic%' GROUP BY "molecule"."label" ORDER BY "atom_count" DESC LIMIT 1;	toxicology
SELECT (COUNT(DISTINCT m."molecule_id") * 100.0 / (SELECT COUNT(DISTINCT "molecule_id") FROM molecule)) AS "percentage" FROM molecule m JOIN bond b ON m."molecule_id" = b."molecule_id" JOIN atom a ON m."molecule_id" = a."molecule_id" WHERE a."element" = 'H' AND b."bond_type" = 'triple' AND m."label" LIKE '%carcinogenic%';	toxicology
SELECT COUNT(DISTINCT "molecule_id") FROM "molecule" WHERE "label" LIKE '%carcinogenic%'	toxicology
SELECT COUNT(DISTINCT "molecule_id") FROM "bond" WHERE "molecule_id" BETWEEN 'TR004' AND 'TR010' AND "bond_type" = 'single';	toxicology
SELECT COUNT(*) FROM atom WHERE "molecule_id" = 'TR008' AND "element" = 'C'	toxicology
SELECT "element" FROM "atom" WHERE "atom_id" = 'TR004_7'	toxicology
SELECT COUNT(DISTINCT "molecule_id") FROM "bond" WHERE "bond_type" = 'double' AND "molecule_id" IN (SELECT "molecule_id" FROM "atom" WHERE "element" = 'O');	toxicology
SELECT COUNT(DISTINCT "molecule"."molecule_id") AS "non_carcinogenic_molecules" FROM "molecule" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "bond"."bond_type" = 'triple' AND "molecule"."label" NOT LIKE '%carcinogenic%';	toxicology
SELECT "a"."element", "b"."bond_type" FROM "atom" AS "a" JOIN "molecule" AS "m" ON "a"."molecule_id" = "m"."molecule_id" JOIN "bond" AS "b" ON "m"."molecule_id" = "b"."molecule_id" WHERE "m"."molecule_id" = 'TR002';	toxicology
SELECT "atom"."atom_id" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" JOIN "bond" ON "molecule"."molecule_id" = "bond"."molecule_id" WHERE "molecule"."label" = 'TR012' AND "bond"."bond_type" = 'double' AND "atom"."element" = 'C';	toxicology
SELECT "atom"."atom_id" FROM "atom" JOIN "molecule" ON "atom"."molecule_id" = "molecule"."molecule_id" WHERE "atom"."element" = 'O' AND "molecule"."label" LIKE '%carcinogenic%';	toxicology
SELECT "name" FROM "cards" WHERE "hasFoil" = 1 AND "power" = 'incredibly powerful';	card_games
SELECT "name", "borderColor" FROM "cards" WHERE "borderColor" = 'borderless' AND "hasFoil" = 0;	card_games
SELECT "name" FROM "cards" WHERE "faceConvertedManaCost" > "convertedManaCost"	card_games
SELECT "name" FROM "cards" WHERE "frameVersion" = '2015' AND "edhrecRank" < 100;	card_games
SELECT "cards"."name" FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "cards"."rarity" = 'mythic' AND "legalities"."format" = 'gladiator' AND "legalities"."status" = 'banned';	card_games
SELECT "legalities"."status" FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "cards"."type" = 'artifact' AND "cards"."isAlternative" = 0 AND "legalities"."format" = 'vintage';	card_games
SELECT "cards"."id", "cards"."artist" FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "cards"."power" IS NULL AND "legalities"."format" = 'Commander' AND "legalities"."status" = 'Legal';	card_games
SELECT "cards"."name", "rulings"."text" FROM "cards" JOIN "rulings" ON "cards"."uuid" = "rulings"."uuid" WHERE "cards"."artist" = 'Stephen Daniel';	card_games
SELECT "rulings"."date", "rulings"."text" FROM "rulings" JOIN "cards" ON "rulings"."uuid" = "cards"."uuid" WHERE "cards"."name" = 'Sublime Epiphany' AND "cards"."number" = '74s';	card_games
SELECT "cards"."name", "cards"."artist", "cards"."isPromo" FROM "cards" JOIN "rulings" ON "cards"."uuid" = "rulings"."uuid" GROUP BY "cards"."uuid" ORDER BY COUNT("rulings"."id") DESC LIMIT 1;	card_games
SELECT "language" FROM "foreign_data" WHERE "name" = 'Annul' AND "multiverseid" = 29;	card_games
SELECT "cards"."name" FROM "cards" JOIN "foreign_data" ON "cards"."uuid" = "foreign_data"."uuid" WHERE "foreign_data"."language" = 'Japanese';	card_games
SELECT (COUNT(CASE WHEN "language" = 'Chinese Simplified' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM foreign_data;	card_games
SELECT "sets"."name", COUNT("cards"."id") AS "total_cards" FROM "sets" JOIN "cards" ON "sets"."code" = "cards"."setCode" JOIN "set_translations" ON "sets"."code" = "set_translations"."setCode" WHERE "set_translations"."language" = 'Italian' GROUP BY "sets"."name";	card_games
SELECT DISTINCT "type" FROM "cards" WHERE "artist" = 'Aaron Boyd';	card_games
SELECT "keywords" FROM "cards" WHERE "name" = 'Angel of Mercy'	card_games
SELECT COUNT("id") FROM "cards" WHERE "power" = 'infinite';	card_games
SELECT "promoTypes" FROM "cards" WHERE "name" = 'Duress'	card_games
SELECT "borderColor" FROM "cards" WHERE "name" = 'Ancestor\'s Chosen'	card_games
SELECT "originalType" FROM "cards" WHERE "name" = 'Ancestor\'s Chosen'	card_games
SELECT DISTINCT "set_translations"."language" FROM "set_translations" JOIN "sets" ON "set_translations"."setCode" = "sets"."code" JOIN "cards" ON "sets"."code" = "cards"."setCode" WHERE "cards"."name" = 'Angel of Mercy';	card_games
SELECT COUNT("cards"."id") FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "legalities"."status" = 'restricted' AND "cards"."text" IS NOT NULL;	card_games
SELECT "text" FROM "rulings" WHERE "uuid" = (SELECT "uuid" FROM "cards" WHERE "name" = 'Condemn')	card_games
SELECT COUNT("cards"."id") FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "legalities"."status" = 'restricted' AND "cards"."isStarter" = 1;	card_games
SELECT "legalities"."status" FROM "legalities" JOIN "cards" ON "legalities"."uuid" = "cards"."uuid" WHERE "cards"."name" = 'Cloudchaser Eagle';	card_games
SELECT "type" FROM "cards" WHERE "name" = 'Benalish Knight'	card_games
SELECT "text" FROM "rulings" WHERE "uuid" = (SELECT "uuid" FROM "cards" WHERE "name" = 'Benalish Knight')	card_games
SELECT DISTINCT "artist" FROM "cards" WHERE "setCode" = 'Phyrexian';	card_games
SELECT (SUM(CASE WHEN "borderColor" = 'borderless' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS "percentage_borderless" FROM "cards";	card_games
SELECT COUNT("id") FROM "cards" WHERE "artist" LIKE '%German%' AND "isReprint" = 1;	card_games
SELECT COUNT("id") FROM "cards" WHERE "borderColor" = 'borderless' AND "artist" IN (SELECT "name" FROM "foreign_data" WHERE "language" = 'Russian');	card_games
SELECT (COUNT(CASE WHEN "language" = 'French' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM cards JOIN foreign_data ON "cards"."uuid" = "foreign_data"."uuid" WHERE "cards"."isStorySpotlight" = 1;	card_games
SELECT COUNT("id") FROM "cards" WHERE "toughness" = '99';	card_games
SELECT "name" FROM "cards" WHERE "artist" = 'Aaron Boyd'	card_games
SELECT COUNT("id") FROM "cards" WHERE "borderColor" = 'black' AND "availability" = 'mtgo';	card_games
SELECT "id" FROM "cards" WHERE "convertedManaCost" = 0	card_games
SELECT "layout" FROM "cards" WHERE "keywords" LIKE '%flying%'	card_games
SELECT COUNT("id") FROM "cards" WHERE "originalType" = 'Summon - Angel' AND "subtypes" != 'Angel';	card_games
SELECT "id" FROM "cards" WHERE "hasFoil" = 1 AND "hasNonFoil" = 1;	card_games
SELECT "id" FROM "cards" WHERE "duelDeck" = 'a'	card_games
SELECT "edhrecRank" FROM "cards" WHERE "frameVersion" = '2015'	card_games
SELECT DISTINCT "artist" FROM "cards" WHERE "id" IN (SELECT "uuid" FROM "foreign_data" WHERE "language" = 'Chinese Simplified');	card_games
SELECT "name" FROM "cards" WHERE "availability" = 'paper' AND "id" IN (SELECT "uuid" FROM "foreign_data" WHERE "language" = 'Japanese')	card_games
SELECT COUNT("cards"."id") FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "legalities"."status" = 'banned' AND "cards"."borderColor" = 'white';	card_games
SELECT DISTINCT "cards"."uuid", "foreign_data"."language" FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" JOIN "foreign_data" ON "cards"."uuid" = "foreign_data"."uuid" WHERE "legalities"."format" = 'Legacy';	card_games
SELECT "text" FROM "rulings" WHERE "uuid" = (SELECT "uuid" FROM "cards" WHERE "name" = 'Beacon of Immortality')	card_games
SELECT COUNT("id") AS "card_count", "legalities"."status" FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "cards"."frameVersion" = 'future' GROUP BY "legalities"."status";	card_games
SELECT DISTINCT "colors" FROM "cards" WHERE "setCode" = 'OGW'	card_games
SELECT "cards"."name", "set_translations"."language" FROM "cards" JOIN "sets" ON "cards"."setCode" = "sets"."code" JOIN "set_translations" ON "sets"."code" = "set_translations"."setCode" WHERE "sets"."code" = '10E' AND "cards"."convertedManaCost" = 5;	card_games
SELECT "cards"."name", "rulings"."date" FROM "cards" JOIN "rulings" ON "cards"."uuid" = "rulings"."uuid" WHERE "cards"."originalType" = 'Creature - Elf';	card_games
SELECT "colors", "uuid" FROM "cards" WHERE "id" BETWEEN 1 AND 20	card_games
SELECT DISTINCT "cards"."name" FROM "cards" JOIN "foreign_data" ON "cards"."uuid" = "foreign_data"."uuid" WHERE "cards"."type" = 'Artifact' AND "cards"."colors" LIKE '%black%';	card_games
SELECT "c"."name" FROM "cards" AS "c" JOIN "rulings" AS "r" ON "c"."uuid" = "r"."uuid" WHERE "c"."rarity" = 'uncommon' ORDER BY "r"."date" ASC LIMIT 3;	card_games
SELECT COUNT("id") FROM "cards" WHERE "artist" = 'John Avon' AND "hasFoil" = 1 AND "power" IS NULL;	card_games
SELECT COUNT("id") FROM "cards" WHERE "borderColor" = 'white' AND "edhrecRank" IS NOT NULL AND "edhrecRank" < 1000;	card_games
SELECT COUNT("id") FROM "cards" WHERE "artist" = 'UDON' AND "availability" = 'mtgo' AND "hand" = '-1';	card_games
SELECT COUNT("id") FROM "cards" WHERE "frameVersion" = '1993' AND "availability" = 'paper' AND "hasContentWarning" = 1;	card_games
SELECT "manaCost" FROM "cards" WHERE "layout" = 'normal' AND "frameVersion" = '2003' AND "borderColor" = 'black' AND "availability" LIKE '%paper%' AND "availability" LIKE '%mtgo%'	card_games
SELECT SUM("convertedManaCost") AS "totalConvertedManaCost" FROM "cards" WHERE "artist" = 'Rob Alexander';	card_games
SELECT DISTINCT "type" FROM "cards" WHERE "isOnlineOnly" = 1	card_games
SELECT DISTINCT "setCode" FROM "set_translations" WHERE "language" = 'Spanish'	card_games
SELECT (COUNT(CASE WHEN "frameEffects" = 'legendary' AND "isOnlineOnly" = 1 THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM "cards" WHERE "isOnlineOnly" = 1;	card_games
SELECT "id" FROM "cards" WHERE "isStorySpotlight" = 1 AND "isTextless" = 1	card_games
SELECT "name", (SELECT COUNT(*) FROM cards) AS total_cards, (SELECT COUNT(*) FROM foreign_data WHERE "language" = 'Spanish') AS spanish_cards, (SELECT COUNT(*) FROM foreign_data WHERE "language" = 'Spanish') * 100.0 / (SELECT COUNT(*) FROM cards) AS percentage FROM foreign_data WHERE "language" = 'Spanish';	card_games
SELECT "language" FROM "set_translations" WHERE "setCode" IN (SELECT "code" FROM "sets" WHERE "totalSetSize" = 309);	card_games
SELECT COUNT("set_translations"."id") FROM "set_translations" JOIN "sets" ON "set_translations"."setCode" = "sets"."code" WHERE "set_translations"."language" = 'Portuguese (Brazil)' AND "sets"."block" = 'Commander';	card_games
SELECT "id" FROM "cards" WHERE "type" LIKE '%Creature%' AND "id" IN (SELECT "uuid" FROM "legalities");	card_games
SELECT DISTINCT "type" FROM "foreign_data" WHERE "language" = 'German';	card_games
SELECT COUNT("id") FROM "cards" WHERE "power" = 'unknown' AND "text" LIKE '%triggered ability%'	card_games
SELECT COUNT(DISTINCT "cards"."id") FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" JOIN "rulings" ON "cards"."uuid" = "rulings"."uuid" WHERE "legalities"."format" = 'pre-modern' AND "rulings"."text" = 'This is a triggered mana ability.' AND "cards"."otherFaceIds" IS NULL;	card_games
SELECT "id" FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "cards"."artist" = 'Erica Yang' AND "legalities"."format" = 'pauper' AND "cards"."availability" = 'paper';	card_games
SELECT "artist" FROM "cards" WHERE "text" = "Das perfekte Gegenmittel zu einer dichten Formation"	card_games
SELECT "name" FROM "foreign_data" WHERE "language" = 'French' AND "uuid" IN (SELECT "uuid" FROM "cards" WHERE "artist" = 'Matthew D. Wilson' AND "type" = 'Creature' AND "layout" = 'normal' AND "borderColor" = 'black');	card_games
SELECT COUNT("cards"."id") FROM "cards" JOIN "rulings" ON "cards"."uuid" = "rulings"."uuid" WHERE "cards"."rarity" = 'print' AND "rulings"."date" = '2007-01-02';	card_games
SELECT DISTINCT "language" FROM "set_translations" WHERE "setCode" = 'Ravnica' LIMIT 1;	card_games
SELECT (COUNT("cards"."id") * 100.0 / (SELECT COUNT("cards"."id") FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "legalities"."format" = 'commander')) AS "percentage" FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "legalities"."format" = 'commander' AND "cards"."hasContentWarning" = 0;	card_games
SELECT (COUNT(CASE WHEN "power" IS NULL THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM "cards" WHERE "id" IN (SELECT "uuid" FROM "foreign_data" WHERE "language" = 'French');	card_games
SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM "sets" s JOIN "set_translations" st ON s."code" = st."setCode" WHERE st."language" = 'Japanese')) AS "percentage" FROM "sets" WHERE "type" = 'expansion' AND "code" IN (SELECT "setCode" FROM "set_translations" WHERE "language" = 'Japanese');	card_games
SELECT "printings" FROM "cards" WHERE "artist" = 'Daren Bader'	card_games
SELECT COUNT(*) FROM "cards" WHERE "colors" IS NOT NULL AND "borderColor" = '' AND "edhrecRank" > 12000;	card_games
SELECT COUNT("id") FROM "cards" WHERE "isOversized" = 1 AND "isReprint" = 1 AND "isPromo" = 1;	card_games
SELECT "name", "power" FROM "cards" WHERE "power" = 'unknown' AND "promoTypes" LIKE '%arena league%' ORDER BY "name" LIMIT 3;	card_games
SELECT "language" FROM "foreign_data" WHERE "multiverseid" = 149934	card_games
SELECT "cards"."id" FROM "cards" WHERE "cards"."cardKingdomFoilId" IS NOT NULL ORDER BY "cards"."cardKingdomFoilId" LIMIT 3;	card_games
SELECT COUNT(*) AS total_cards, SUM(CASE WHEN "layout" != 'normal' THEN 1 ELSE 0 END) AS non_normal_layout_cards FROM "cards";	card_games
SELECT "number" FROM "cards" WHERE "isAlternative" = 0 AND "subtypes" LIKE '%Angel%' AND "subtypes" LIKE '%Wizard%'	card_games
SELECT "name", "code" FROM "sets" WHERE "isOnlineOnly" = 0 ORDER BY "name" ASC LIMIT 3;	card_games
SELECT DISTINCT "language" FROM "set_translations" WHERE "setCode" = 'ARC'	card_games
SELECT "sets"."name", "set_translations"."translation" FROM "sets" JOIN "set_translations" ON "sets"."code" = "set_translations"."setCode" WHERE "sets"."id" = 5;	card_games
SELECT "language", "type" FROM SETS JOIN set_translations ON sets."code" = set_translations."setCode" WHERE sets."id" = 206	card_games
SELECT "sets"."id", "sets"."name" FROM "sets" JOIN "set_translations" ON "sets"."code" = "set_translations"."setCode" WHERE "set_translations"."language" = 'Italian' AND "sets"."block" = 'Shadowmoor' ORDER BY "sets"."name" LIMIT 2;	card_games
SELECT "id", "name" FROM "sets" WHERE "isForeignOnly" = 1 AND "isFoilOnly" = 1;	card_games
SELECT "sets"."name", COUNT("cards"."id") AS "card_count" FROM "sets" JOIN "cards" ON "sets"."code" = "cards"."setCode" WHERE "sets"."name" LIKE '%Russian%' GROUP BY "sets"."name" ORDER BY "card_count" DESC LIMIT 1;	card_games
SELECT (COUNT("cards"."id") * 100.0 / (SELECT COUNT("id") FROM "cards")) AS "percentage" FROM "cards" JOIN "foreign_data" ON "cards"."uuid" = "foreign_data"."uuid" WHERE "foreign_data"."language" = 'Chinese Simplified' AND "cards"."isOnlineOnly" = 1;	card_games
SELECT COUNT("id") FROM "sets" WHERE "isOnlineOnly" = 0 AND "code" = 'ja'	card_games
SELECT "id" FROM "cards" WHERE "borderColor" = 'black'	card_games
SELECT "id" FROM "cards" WHERE "frameEffects" = 'extendedart'	card_games
SELECT "name" FROM "cards" WHERE "borderColor" = 'black' AND "isFullArt" = 1;	card_games
SELECT "language" FROM "sets" JOIN "set_translations" ON "sets"."code" = "set_translations"."setCode" WHERE "sets"."id" = 174	card_games
SELECT "name" FROM "sets" WHERE "code" = 'ALL'	card_games
SELECT "language" FROM "foreign_data" WHERE "name" = 'A Pedra Fellwar'	card_games
SELECT "code" FROM "sets" WHERE "releaseDate" = '2007-07-13'	card_games
SELECT "baseSetSize", "code" FROM "sets" WHERE "block" IN ('Masques', 'Mirage')	card_games
SELECT "code" FROM "sets" WHERE "type" = 'expansion'	card_games
SELECT "name", "type" FROM "foreign_data" WHERE "uuid" IN (SELECT "uuid" FROM "cards" WHERE "watermark" = 'boros')	card_games
SELECT "language", "flavorText", "type" FROM "foreign_data" JOIN "cards" ON "foreign_data"."uuid" = "cards"."uuid" WHERE "cards"."watermark" = 'colorpie';	card_games
SELECT (COUNT("cards"."id") * 100.0 / (SELECT COUNT("id") FROM "cards" WHERE "setCode" = 'Abyssal Horror')) AS "percentage" FROM "cards" WHERE "convertedManaCost" = 10 AND "setCode" = 'Abyssal Horror';	card_games
SELECT "code" FROM "sets" WHERE "type" = 'commander'	card_games
SELECT "foreign_data"."name", "cards"."type" FROM "foreign_data" JOIN "cards" ON "foreign_data"."uuid" = "cards"."uuid" WHERE "cards"."watermark" = 'abzan';	card_games
SELECT "foreign_data"."language", "cards"."type" FROM "cards" JOIN "foreign_data" ON "cards"."uuid" = "foreign_data"."uuid" WHERE "cards"."watermark" = 'azorius';	card_games
SELECT COUNT("id") FROM "cards" WHERE "artist" = 'Aaron Miller' AND "power" = 'incredibly powerful';	card_games
SELECT COUNT("id") FROM "cards" WHERE "availability" = 'paper' AND "hand" = 'positive'	card_games
SELECT "name" FROM "cards" WHERE "text" IS NOT NULL	card_games
SELECT "convertedManaCost" FROM "cards" WHERE "name" = 'Ancestor\'s Chosen'	card_games
SELECT COUNT("id") FROM "cards" WHERE "borderColor" = 'white' AND "power" = 'unknown';	card_games
SELECT "name" FROM "cards" WHERE "isPromo" = 1 AND "otherFaceIds" IS NOT NULL;	card_games
SELECT "types" FROM "cards" WHERE "name" = 'Molimo, Maro-Sorcerer'	card_games
SELECT DISTINCT "purchaseUrls" FROM "cards" WHERE "promoTypes" LIKE '%bundle%'	card_games
SELECT COUNT(DISTINCT "artist") FROM "cards" WHERE "borderColor" = 'black' AND "availability" IN ('arena', 'mtgo');	card_games
SELECT "name", "convertedManaCost" FROM "cards" WHERE "name" IN ('Serra Angel', 'Shrine Keeper');	card_games
SELECT "artist" FROM "cards" WHERE "name" = 'Battra, Dark Destroyer'	card_games
SELECT "name" FROM "cards" WHERE "convertedManaCost" IS NOT NULL AND "frameVersion" = '2003' ORDER BY "convertedManaCost" DESC LIMIT 3;	card_games
SELECT "setCode" FROM "cards" WHERE "name" = 'Ancestor\'s Chosen'	card_games
SELECT COUNT("setCode") FROM "sets" WHERE "id" IN (SELECT "uuid" FROM "cards" WHERE "name" = 'Angel of Mercy')	card_games
SELECT "name" FROM "cards" WHERE "setCode" = 'Hauptset Zehnte Edition'	card_games
SELECT "setCode" FROM "sets" WHERE "name" = "Ancestor's Chosen"	card_games
SELECT COUNT("id") FROM "cards" WHERE "setCode" = 'Hauptset Zehnte Edition' AND "artist" = 'Adam Rex';	card_games
SELECT COUNT("id") FROM "cards" WHERE "setCode" = 'Hauptset Zehnte Edition';	card_games
SELECT "translation" FROM "set_translations" WHERE "setCode" = '8ED' AND "language" = 'zh-Hans'	card_games
SELECT "isOnlineOnly" FROM "cards" WHERE "name" = 'Angel of Mercy'	card_games
SELECT "releaseDate" FROM "sets" WHERE "id" IN (SELECT "setCode" FROM "cards" WHERE "name" = 'Ancestor\'s Chosen')	card_games
SELECT "type" FROM "sets" WHERE "name" = 'Hauptset Zehnte Edition'	card_games
SELECT COUNT(DISTINCT "sets"."id") FROM "sets" JOIN "set_translations" ON "sets"."code" = "set_translations"."setCode" WHERE "sets"."block" = 'Ice Age' AND "set_translations"."language" = 'Italian';	card_games
SELECT "availability" FROM "cards" WHERE "name" = 'Adarkar Valkyrie'	card_games
SELECT COUNT("sets"."id") FROM "sets" JOIN "set_translations" ON "sets"."code" = "set_translations"."setCode" WHERE "set_translations"."language" = 'Italian' AND "sets"."baseSetSize" < 100;	card_games
SELECT COUNT("id") FROM "cards" WHERE "borderColor" = 'black' AND "setCode" = 'CSP';	card_games
SELECT "name" FROM "cards" WHERE "setCode" = 'Coldsnap' AND "convertedManaCost" = (SELECT MAX("convertedManaCost") FROM "cards" WHERE "setCode" = 'Coldsnap');	card_games
SELECT DISTINCT "artist" FROM "cards" JOIN "sets" ON "cards"."setCode" = "sets"."code" WHERE "sets"."name" = 'Coldsnap' AND "artist" IN ('Jeremy Jarvis', 'Aaron Miller', 'Chippy');	card_games
SELECT "number", "name" FROM "cards" WHERE "setCode" = 'Coldsnap' AND "number" = '4'	card_games
SELECT COUNT(*) FROM "cards" WHERE "convertedManaCost" > 5 AND "setCode" = 'CSP' AND "power" IS NULL;	card_games
SELECT "flavorText" FROM "foreign_data" WHERE "name" = 'Ancestor\'s Chosen' AND "language" = 'Italian';	card_games
SELECT DISTINCT "language" FROM "foreign_data" WHERE "name" = 'Ancestor\'s Chosen' AND "flavorText" IS NOT NULL;	card_games
SELECT "type" FROM "cards" WHERE "name" = 'Ancestor\'s Chosen'	card_games
SELECT "text" FROM "rulings" WHERE "uuid" IN (SELECT "uuid" FROM "cards" WHERE "setCode" = 'CSP') AND "language" = 'Italian';	card_games
SELECT "foreign_data"."name" FROM "foreign_data" JOIN "sets" ON "foreign_data"."uuid" = "sets"."code" JOIN "cards" ON "sets"."code" = "cards"."setCode" WHERE "sets"."name" = 'Coldsnap' AND "cards"."convertedManaCost" = (SELECT MAX("convertedManaCost") FROM "cards" WHERE "setCode" = "sets"."code") AND "foreign_data"."language" = 'Italian';	card_games
SELECT "date" FROM "rulings" WHERE "uuid" = (SELECT "uuid" FROM "cards" WHERE "name" = 'Reminisce')	card_games
SELECT (COUNT(CASE WHEN "convertedManaCost" = 7 THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM "cards" JOIN "sets" ON "cards"."setCode" = "sets"."code" WHERE "sets"."name" = 'Coldsnap';	card_games
SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM "cards" WHERE "setCode" = 'CSP')) AS "percentage" FROM "cards" WHERE "setCode" = 'CSP' AND "power" = 'incredibly powerful';	card_games
SELECT "code" FROM "sets" WHERE "releaseDate" = '2017-07-14'	card_games
SELECT "keyruneCode" FROM "sets" WHERE "code" = 'PKHC';	card_games
SELECT "mcmId" FROM "sets" WHERE "code" = 'SS2'	card_games
SELECT "name" FROM "sets" WHERE "releaseDate" = '2017-06-09'	card_games
SELECT "type" FROM "sets" WHERE "name" = 'From the Vault: Lore'	card_games
SELECT "parentCode" FROM "sets" WHERE "name" = 'Commander 2014 Oversized'	card_games
SELECT "cards"."name", "rulings"."text" FROM "cards" JOIN "rulings" ON "cards"."uuid" = "rulings"."uuid" WHERE "cards"."artist" = 'Jim Pavelec';	card_games
SELECT "sets"."releaseDate" FROM "sets" JOIN "cards" ON "sets"."code" = "cards"."setCode" WHERE "cards"."name" = 'Evacuation'	card_games
SELECT COUNT("id") FROM "sets" WHERE "name" = 'Rinascita di Alara';	card_games
SELECT "type" FROM "sets" WHERE "name" = 'Huitième édition'	card_games
SELECT "setCode", "name" FROM "sets" JOIN "cards" ON "sets"."code" = "cards"."setCode" WHERE "cards"."name" = 'Tendo Ice Bridge';	card_games
SELECT COUNT("id") FROM "set_translations" WHERE "setCode" = 'Tenth Edition'	card_games
SELECT "set_translations"."translation" FROM "set_translations" JOIN "cards" ON "set_translations"."setCode" = "cards"."setCode" WHERE "cards"."name" = 'Fellwar Stone' AND "set_translations"."language" = 'Japanese';	card_games
SELECT "name", "convertedManaCost" FROM "cards" WHERE "setCode" = 'JOU' ORDER BY "convertedManaCost" DESC LIMIT 1	card_games
SELECT "releaseDate" FROM "sets" WHERE "name" = 'Ola de frío'	card_games
SELECT "sets"."type" FROM "sets" JOIN "cards" ON "sets"."code" = "cards"."setCode" WHERE "cards"."name" = 'Samite Pilgrim'	card_games
SELECT COUNT("cards"."id") FROM "cards" JOIN "sets" ON "cards"."setCode" = "sets"."code" WHERE "sets"."name" = 'World Championship Decks 2004' AND "cards"."convertedManaCost" = 3;	card_games
SELECT "translation" FROM "set_translations" WHERE "setCode" = 'Mirrodin' AND "language" = 'Simplified Chinese'	card_games
SELECT (SUM(CASE WHEN "isNonFoilOnly" = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS "percentage_non_foil" FROM SETS JOIN set_translations ON "sets"."code" = "set_translations"."setCode" WHERE "set_translations"."language" = 'Japanese';	card_games
SELECT (COUNT(CASE WHEN "isOnlineOnly" = 1 THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM "sets" JOIN "set_translations" ON "sets"."code" = "set_translations"."setCode" WHERE "set_translations"."language" = 'Brazil Portuguese';	card_games
SELECT DISTINCT "printings" FROM "cards" WHERE "artist" = 'Aleksi Briclot' AND "text" IS NULL;	card_games
SELECT "sets"."id" FROM "sets" JOIN "cards" ON "sets"."code" = "cards"."setCode" GROUP BY "sets"."id" ORDER BY COUNT("cards"."id") DESC LIMIT 1;	card_games
SELECT "artist" FROM "cards" WHERE "faceConvertedManaCost" IS NULL ORDER BY "convertedManaCost" DESC LIMIT 1	card_games
SELECT "frameEffects", COUNT("frameEffects") AS "count" FROM "cards" WHERE "hasFoil" = 1 AND "isPromo" = 1 GROUP BY "frameEffects" ORDER BY "count" DESC LIMIT 1	card_games
SELECT COUNT("id") FROM "cards" WHERE "power" IS NULL AND "duelDeck" = 'A' AND "hasFoil" = 0;	card_games
SELECT "id" FROM "sets" WHERE "type" = 'Commander' ORDER BY "totalSetSize" DESC LIMIT 1;	card_games
SELECT "name", "convertedManaCost" FROM "cards" ORDER BY "convertedManaCost" DESC LIMIT 10	card_games
SELECT "originalReleaseDate", "format" FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "rarity" = 'Mythic' ORDER BY "originalReleaseDate" ASC LIMIT 1	card_games
SELECT COUNT("cards"."id") FROM "cards" JOIN "foreign_data" ON "cards"."uuid" = "foreign_data"."uuid" WHERE "cards"."artist" = 'Volkan BaÇµa' AND "foreign_data"."language" = 'French';	card_games
SELECT COUNT("cards"."id") FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "cards"."type" = 'enchantment' AND "cards"."name" = 'Abundance' AND "legalities"."status" = 'legal' AND "cards"."rarity" = 'rare';	card_games
SELECT "legalities"."format", "cards"."name" FROM "legalities" JOIN "cards" ON "legalities"."uuid" = "cards"."uuid" WHERE "legalities"."status" = 'banned' GROUP BY "legalities"."format" ORDER BY COUNT("legalities"."status") DESC LIMIT 1;	card_games
SELECT "language" FROM "set_translations" WHERE "setCode" = 'Battlebond'	card_games
SELECT "artist", "format" FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" GROUP BY "artist" ORDER BY COUNT("cards"."id") ASC LIMIT 1	card_games
SELECT "legalities"."status" FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "cards"."frameVersion" = '1997' AND "cards"."artist" = 'D. Alexander Gregory' AND "legalities"."format" = 'Legacy' AND "cards"."hasContentWarning" = 1;	card_games
SELECT "name", "uuid" FROM "cards" WHERE "edhrecRank" = 1	card_games
SELECT COUNT("id") / 4 AS "average_sets", "language" FROM "sets" JOIN "set_translations" ON "sets"."code" = "set_translations"."setCode" WHERE "releaseDate" BETWEEN '2012-01-01' AND '2015-12-31' GROUP BY "language";	card_games
SELECT DISTINCT "artist" FROM "cards" WHERE "borderColor" = 'black' AND "isOnlineOnly" = 1 AND "availability" LIKE '%arena%';	card_games
SELECT "cards"."uuid" FROM "cards" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "legalities"."format" = 'Old School' AND ("legalities"."status" = 'restricted' OR "legalities"."status" = 'banned');	card_games
SELECT COUNT("id") FROM "cards" WHERE "artist" = 'Matthew D. Wilson' AND "availability" = 'paper'	card_games
SELECT "rulings"."text", "rulings"."date" FROM "rulings" JOIN "cards" ON "rulings"."uuid" = "cards"."uuid" WHERE "cards"."artist" = 'Kev Walker' ORDER BY "rulings"."date" DESC	card_games
SELECT "cards"."name", "legalities"."format" FROM "cards" JOIN "sets" ON "cards"."setCode" = "sets"."code" JOIN "legalities" ON "cards"."uuid" = "legalities"."uuid" WHERE "sets"."name" = 'Hour of Devastation';	card_games
SELECT "sets"."name" FROM "sets" LEFT JOIN "set_translations" ON "sets"."code" = "set_translations"."setCode" WHERE "set_translations"."language" = 'Korean' AND "sets"."code" NOT IN (SELECT "setCode" FROM "set_translations" WHERE "language" = 'Japanese');	card_games
SELECT DISTINCT "frameVersion", "name" FROM "cards" WHERE "artist" = 'Allen Williams' AND "uuid" IN (SELECT "uuid" FROM "legalities" WHERE "status" = 'banned')	card_games
SELECT "DisplayName", "Reputation" FROM "users" WHERE "DisplayName" IN ('Harlan', 'Jarrod Dixon')	codebase_community
SELECT "DisplayName" FROM "users" WHERE strftime('%Y', "CreationDate") = '2011'	codebase_community
SELECT COUNT("Id") FROM "users" WHERE "LastAccessDate" > '2014-09-01'	codebase_community
SELECT "DisplayName" FROM "users" ORDER BY "Views" DESC LIMIT 1	codebase_community
SELECT COUNT(*) FROM "users" WHERE "UpVotes" > 100 AND "DownVotes" > 1;	codebase_community
SELECT COUNT("Id") FROM "users" WHERE "Views" > 10 AND date("CreationDate") > '2013-01-01'	codebase_community
SELECT COUNT("Id") FROM "posts" WHERE "OwnerDisplayName" = 'csgillespie'	codebase_community
SELECT "Title" FROM "posts" WHERE "OwnerDisplayName" = 'csgillespie'	codebase_community
SELECT "OwnerDisplayName" FROM "posts" WHERE "Title" = 'Eliciting priors from experts'	codebase_community
SELECT "Title" FROM "posts" WHERE "OwnerDisplayName" = 'csgillespie' ORDER BY "Score" DESC LIMIT 1	codebase_community
SELECT "users"."DisplayName" FROM "posts" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" ORDER BY "posts"."Score" DESC LIMIT 1;	codebase_community
SELECT SUM("CommentCount") AS "TotalComments" FROM "posts" WHERE "OwnerDisplayName" = 'csgillespie';	codebase_community
SELECT "AnswerCount" FROM "posts" WHERE "OwnerDisplayName" = 'csgillespie' ORDER BY "AnswerCount" DESC LIMIT 1;	codebase_community
SELECT "users"."DisplayName" FROM "posts" JOIN "users" ON "posts"."LastEditorUserId" = "users"."Id" WHERE "posts"."Title" = "Examples for teaching: Correlation does not mean causation";	codebase_community
SELECT COUNT("Id") FROM "posts" WHERE "OwnerDisplayName" = 'csgillespie' AND "ParentId" IS NULL;	codebase_community
SELECT DISTINCT "users"."DisplayName" FROM "users" JOIN "posts" ON "users"."Id" = "posts"."OwnerUserId" WHERE "posts"."AnswerCount" > 0 AND "posts"."CommentCount" > 0;	codebase_community
SELECT COUNT("posts"."Id") AS "PostCount" FROM "posts" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" WHERE "users"."Age" > 60 AND "posts"."Score" > 19;	codebase_community
SELECT "users"."Location" FROM "posts" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" WHERE "posts"."Title" = 'Eliciting priors from experts'	codebase_community
SELECT "posts"."Body" FROM "posts" JOIN "tags" ON "posts"."Id" = "tags"."ExcerptPostId" WHERE "tags"."TagName" = 'bayesian'	codebase_community
SELECT "posts"."Body" FROM "posts" JOIN "tags" ON "posts"."Id" = "tags"."ExcerptPostId" ORDER BY "tags"."Count" DESC LIMIT 1	codebase_community
SELECT COUNT("Id") FROM "badges" WHERE "UserId" = (SELECT "Id" FROM "users" WHERE "DisplayName" = 'csgillespie')	codebase_community
SELECT "badges"."Name" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "users"."DisplayName" = 'csgillespie'	codebase_community
SELECT COUNT("badges"."Id") AS "BadgeCount" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "users"."DisplayName" = 'csgillespie' AND strftime('%Y', "badges"."Date") = '2011';	codebase_community
SELECT "users"."DisplayName" FROM "users" JOIN "badges" ON "users"."Id" = "badges"."UserId" GROUP BY "users"."Id" ORDER BY COUNT("badges"."Id") DESC LIMIT 1	codebase_community
SELECT AVG("Score") FROM "posts" WHERE "OwnerDisplayName" = 'csgillespie'	codebase_community
SELECT AVG("badge_count") FROM (SELECT COUNT("Id") AS "badge_count" FROM "badges" GROUP BY "UserId" HAVING "UserId" IN (SELECT "Id" FROM "users" WHERE "Views" > 200));	codebase_community
SELECT COUNT(CASE WHEN "Age" > 60 THEN 1 END) * 100.0 / COUNT(*) AS "Percentage" FROM "posts" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" WHERE "posts"."Score" > 5;	codebase_community
SELECT COUNT("Id") FROM "votes" WHERE "UserId" = 58 AND date("CreationDate") = '2010-07-19'	codebase_community
SELECT "CreationDate" FROM "votes" WHERE "PostId" = (SELECT "PostId" FROM "votes" GROUP BY "PostId" ORDER BY COUNT(*) DESC LIMIT 1)	codebase_community
SELECT COUNT("Id") FROM "badges" WHERE "Name" = 'Revival'	codebase_community
SELECT "posts"."Title" FROM "posts" JOIN "comments" ON "posts"."Id" = "comments"."PostId" ORDER BY "comments"."Score" DESC LIMIT 1	codebase_community
SELECT "CommentCount" FROM "posts" WHERE "ViewCount" = 1910	codebase_community
SELECT "FavoriteCount" FROM "posts" WHERE "Id" = (SELECT "PostId" FROM "comments" WHERE "UserId" = 3025 AND "CreationDate" = '2014-04-23 20:29:39')	codebase_community
SELECT "Text" FROM "comments" WHERE "PostId" = 107829 LIMIT 1	codebase_community
SELECT "Score" FROM "posts" WHERE "Id" = (SELECT "PostId" FROM "comments" WHERE "UserId" = 23853 AND "CreationDate" = '2013-07-12 09:08:18')	codebase_community
SELECT "users"."Reputation" FROM "posts" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" WHERE "posts"."Id" = 65041	codebase_community
SELECT COUNT("Id") FROM "posts" WHERE "OwnerDisplayName" = 'Tiago Pasqualini'	codebase_community
SELECT "users"."DisplayName" FROM "votes" JOIN "users" ON "votes"."UserId" = "users"."Id" WHERE "votes"."Id" = 6347;	codebase_community
SELECT COUNT("Id") AS "VoteCount" FROM "votes" WHERE "PostId" IN (SELECT "Id" FROM "posts" WHERE "Title" LIKE '%data visualization%')	codebase_community
SELECT "badges"."Name" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "users"."DisplayName" = 'DatEpicCoderGuyWhoPrograms';	codebase_community
SELECT COUNT("posts"."Id") AS "PostCount", COUNT("votes"."Id") AS "VoteCount" FROM "posts" LEFT JOIN "votes" ON "posts"."Id" = "votes"."PostId" WHERE "posts"."OwnerUserId" = 24;	codebase_community
SELECT "ViewCount" FROM "posts" WHERE "Title" = 'Integration of Weka and/or RapidMiner into Informatica PowerCenter/Developer'	codebase_community
SELECT "Text" FROM "comments" WHERE "Score" = 17	codebase_community
SELECT "DisplayName" FROM "users" WHERE "WebsiteUrl" = 'http://stackoverflow.com'	codebase_community
SELECT "badges"."Name" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "users"."DisplayName" = 'SilentGhost';	codebase_community
SELECT "UserDisplayName" FROM "comments" WHERE "Text" = 'thank you user93!'	codebase_community
SELECT "Text", "CreationDate" FROM "comments" WHERE "UserDisplayName" = 'A Lion.'	codebase_community
SELECT "users"."Reputation", "users"."DisplayName" FROM "posts" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" WHERE "posts"."Title" = 'Understanding what Dassault iSight is doing?'	codebase_community
SELECT "comments"."Text", "comments"."CreationDate", "comments"."UserDisplayName" FROM "comments" JOIN "posts" ON "comments"."PostId" = "posts"."Id" WHERE "posts"."Title" = 'How does gentle boosting differ from AdaBoost?'	codebase_community
SELECT "users"."DisplayName" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "badges"."Name" = 'Necromancer' LIMIT 10;	codebase_community
SELECT "LastEditorDisplayName" FROM "posts" WHERE "Title" = 'Open source tools for visualizing multi-dimensional data'	codebase_community
SELECT "Title" FROM "posts" WHERE "LastEditorDisplayName" = 'Vebjorn Ljosa';	codebase_community
SELECT SUM("posts"."Score") AS "TotalScore", "users"."WebsiteUrl" FROM "posts" JOIN "users" ON "posts"."LastEditorUserId" = "users"."Id" WHERE "users"."DisplayName" = 'Yevgeny';	codebase_community
SELECT "comments"."Text" FROM "comments" JOIN "posts" ON "comments"."PostId" = "posts"."Id" WHERE "posts"."Title" = 'Why square the difference instead of taking the absolute value in standard deviation?'	codebase_community
SELECT SUM("BountyAmount") FROM "votes" JOIN "posts" ON "votes"."PostId" = "posts"."Id" WHERE "posts"."Title" LIKE '%data%'	codebase_community
SELECT "users"."DisplayName" FROM "votes" JOIN "posts" ON "votes"."PostId" = "posts"."Id" JOIN "users" ON "votes"."UserId" = "users"."Id" WHERE "votes"."BountyAmount" = 50 AND "posts"."Title" LIKE '%variance%'	codebase_community
SELECT "posts"."Title", "comments"."Text", AVG("posts"."ViewCount") AS "AverageViewCount" FROM "posts" JOIN "comments" ON "posts"."Id" = "comments"."PostId" WHERE "posts"."Tags" LIKE '%humor%' GROUP BY "posts"."Id", "comments"."Text";	codebase_community
SELECT COUNT("Id") AS "TotalComments" FROM "comments" WHERE "UserId" = 13;	codebase_community
SELECT "Id" FROM "users" ORDER BY "Reputation" DESC LIMIT 1	codebase_community
SELECT "Id" FROM "users" ORDER BY "Views" ASC LIMIT 1	codebase_community
SELECT COUNT(DISTINCT "UserId") FROM "badges" WHERE "Name" = 'supporter' AND strftime('%Y', "Date") = '2011';	codebase_community
SELECT COUNT(DISTINCT "UserId") FROM "badges" GROUP BY "UserId" HAVING COUNT("Id") > 5	codebase_community
SELECT COUNT(DISTINCT "users"."Id") FROM "users" JOIN "badges" ON "users"."Id" = "badges"."UserId" WHERE "users"."Location" = 'New York' AND "badges"."Name" IN ('teacher', 'supporter') GROUP BY "users"."Id" HAVING COUNT(DISTINCT "badges"."Name") = 2;	codebase_community
SELECT "users"."DisplayName", "users"."Reputation" FROM "posts" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" WHERE "posts"."Id" = 1;	codebase_community
SELECT "users"."Id", "users"."DisplayName" FROM "users" JOIN "posts" ON "users"."Id" = "posts"."OwnerUserId" JOIN "postHistory" ON "posts"."Id" = "postHistory"."PostId" GROUP BY "posts"."Id", "users"."Id" HAVING COUNT("postHistory"."Id") = 1 AND SUM("posts"."ViewCount") >= 1000;	codebase_community
SELECT "users"."DisplayName", COUNT("comments"."Id") AS "CommentCount", "badges"."Name" FROM "users" JOIN "comments" ON "users"."Id" = "comments"."UserId" JOIN "badges" ON "users"."Id" = "badges"."UserId" GROUP BY "users"."Id" ORDER BY "CommentCount" DESC;	codebase_community
SELECT COUNT(DISTINCT "users"."Id") AS "UserCount" FROM "users" JOIN "badges" ON "users"."Id" = "badges"."UserId" WHERE "users"."Location" = 'India' AND "badges"."Name" = 'teacher';	codebase_community
SELECT (SELECT COUNT(*) FROM "badges" WHERE strftime('%Y', "Date") = '2010') AS "Badges2010", (SELECT COUNT(*) FROM "badges" WHERE strftime('%Y', "Date") = '2011') AS "Badges2011";	codebase_community
SELECT "PostHistoryTypeId", COUNT(DISTINCT "UserId") AS "UniqueUserCount" FROM "postHistory" WHERE "PostId" = 3720 GROUP BY "PostHistoryTypeId"	codebase_community
SELECT "relatedPostId", "LinkTypeId" FROM "postLinks" WHERE "PostId" = 61217	codebase_community
SELECT "Score", "LinkTypeId" FROM "posts" JOIN "postLinks" ON "posts"."Id" = "postLinks"."PostId" WHERE "posts"."Id" = 395	codebase_community
SELECT "posts"."Id", "posts"."OwnerUserId" FROM "posts" WHERE "posts"."Score" > 60	codebase_community
SELECT SUM("FavoriteCount") FROM "posts" WHERE "OwnerUserId" = 686 AND strftime('%Y', "CreaionDate") = '2011'	codebase_community
SELECT AVG("UpVotes") AS "AverageUpVotes", AVG("Age") AS "AverageUserAge" FROM "users" JOIN (SELECT "OwnerUserId" FROM "posts" GROUP BY "OwnerUserId" HAVING COUNT("Id") > 10) AS "PostCounts" ON "users"."Id" = "PostCounts"."OwnerUserId"	codebase_community
SELECT COUNT(DISTINCT "UserId") FROM "badges" WHERE "Name" = 'Announcer'	codebase_community
SELECT "Name" FROM "badges" WHERE "Date" = '2010-07-19 19:39:08'	codebase_community
SELECT COUNT("Id") FROM "comments" WHERE "Score" > 0;	codebase_community
SELECT "Text" FROM "comments" WHERE "CreationDate" = '2010-07-19 19:25:47'	codebase_community
SELECT COUNT("Id") FROM "posts" WHERE "Score" = 10;	codebase_community
SELECT "Name" FROM "badges" WHERE "UserId" IN (SELECT "Id" FROM "users" ORDER BY "Reputation" DESC LIMIT 1)	codebase_community
SELECT "users"."Reputation" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "badges"."Date" = '2010-07-19 19:39:08';	codebase_community
SELECT "badges"."Name" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "users"."DisplayName" = 'Pierre';	codebase_community
SELECT DISTINCT "badges"."Date" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "users"."Location" = 'Rochester, NY'	codebase_community
SELECT COUNT(DISTINCT "UserId") * 100.0 / (SELECT COUNT(*) FROM "users") AS "Percentage" FROM "badges" WHERE "Name" = 'Teacher';	codebase_community
SELECT COUNT(DISTINCT "users"."Id") AS "TotalUsers", SUM(CASE WHEN "users"."Age" BETWEEN 13 AND 19 THEN 1 ELSE 0 END) AS "Teenagers" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "badges"."Name" = 'Organizer';	codebase_community
SELECT "Score" FROM "comments" WHERE "PostId" = (SELECT "Id" FROM "posts" WHERE "CreaionDate" = '2010-07-19 19:19:56')	codebase_community
SELECT "Text" FROM "comments" WHERE "PostId" IN (SELECT "Id" FROM "posts" WHERE "CreaionDate" = '2010-07-19 19:37:33');	codebase_community
SELECT "users"."Age" FROM "users" JOIN "badges" ON "users"."Id" = "badges"."UserId" WHERE "users"."Location" = 'Vienna, Austria';	codebase_community
SELECT COUNT(DISTINCT "UserId") FROM "badges" WHERE "Name" = 'Supporter' AND "UserId" IN (SELECT "Id" FROM "users" WHERE "Age" >= 18)	codebase_community
SELECT "users"."Views" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "badges"."Date" = '2010-07-19 19:39:08';	codebase_community
SELECT "badges"."Name" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "users"."Reputation" = (SELECT MIN("Reputation") FROM "users");	codebase_community
SELECT "badges"."Name" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "users"."DisplayName" = 'Sharpie';	codebase_community
SELECT COUNT(DISTINCT "UserId") FROM "badges" WHERE "Name" = 'Supporter'	codebase_community
SELECT "DisplayName" FROM "users" WHERE "Id" = 30;	codebase_community
SELECT COUNT("Id") FROM "users" WHERE "Location" = 'New York'	codebase_community
SELECT COUNT("Id") FROM "votes" WHERE date("CreationDate") BETWEEN '2010-01-01' AND '2010-12-31';	codebase_community
SELECT COUNT("Id") FROM "users" WHERE "Age" >= 18	codebase_community
SELECT "DisplayName", "Views" FROM "users" ORDER BY "Views" DESC LIMIT 1	codebase_community
SELECT (SELECT COUNT(*) FROM "votes" WHERE date("CreationDate") BETWEEN '2010-01-01' AND '2010-12-31') AS "Votes2010", (SELECT COUNT(*) FROM "votes" WHERE date("CreationDate") BETWEEN '2011-01-01' AND '2011-12-31') AS "Votes2011";	codebase_community
SELECT "tags"."TagName" FROM "tags" JOIN "posts" ON "tags"."ExcerptPostId" = "posts"."Id" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" WHERE "users"."DisplayName" = 'John Salvatier'	codebase_community
SELECT COUNT("Id") FROM "posts" WHERE "OwnerDisplayName" = 'Daniel Vassallo'	codebase_community
SELECT COUNT("Id") FROM "votes" WHERE "UserId" = (SELECT "Id" FROM "users" WHERE "DisplayName" = 'Harlan')	codebase_community
SELECT "Id" FROM "posts" WHERE "OwnerDisplayName" = 'slashnick' ORDER BY "AnswerCount" DESC LIMIT 1	codebase_community
SELECT "OwnerDisplayName", "Score" FROM "posts" WHERE "OwnerDisplayName" IN ('Harvey Motulsky', 'Noah Snyder') ORDER BY "Score" DESC LIMIT 1	codebase_community
SELECT COUNT("posts"."Id") FROM "posts" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" WHERE "users"."DisplayName" = 'Matt Parker' AND "posts"."Score" > 4;	codebase_community
SELECT COUNT("c"."Id") AS "NegativeCommentCount" FROM "comments" AS "c" JOIN "users" AS "u" ON "c"."UserId" = "u"."Id" WHERE "u"."DisplayName" = 'Neil McGuigan' AND "c"."Score" < 0;	codebase_community
SELECT DISTINCT "tags"."TagName" FROM "tags" JOIN "posts" ON "tags"."ExcerptPostId" = "posts"."Id" WHERE "posts"."OwnerDisplayName" = 'Mark Meckes' AND "posts"."CommentCount" = 0;	codebase_community
SELECT "users"."DisplayName" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "badges"."Name" = 'Organizer';	codebase_community
SELECT (COUNT(CASE WHEN "Tags" LIKE '%R%' THEN 1 END) * 100.0 / COUNT(*)) AS "PercentageOfRPosts" FROM "posts" WHERE "OwnerDisplayName" = 'Community';	codebase_community
SELECT (SELECT SUM("ViewCount") FROM "posts" WHERE "OwnerDisplayName" = 'Mornington') - (SELECT SUM("ViewCount") FROM "posts" WHERE "OwnerDisplayName" = 'Amos') AS "ViewCountDifference"	codebase_community
SELECT COUNT(DISTINCT "UserId") FROM "badges" WHERE "Name" = 'commentator' AND strftime('%Y', "Date") = '2014';	codebase_community
SELECT COUNT("Id") FROM "posts" WHERE DATE("CreaionDate") = '2010-07-21'	codebase_community
SELECT "DisplayName", "Age" FROM "users" WHERE "Views" = (SELECT MAX("Views") FROM "users")	codebase_community
SELECT "LastEditDate", "LastEditorUserId" FROM "posts" WHERE "Title" = 'Detecting a given face in a database of facial images'	codebase_community
SELECT COUNT("Id") FROM "comments" WHERE "UserId" = 13 AND "Score" < 0	codebase_community
SELECT "posts"."Title", "comments"."UserDisplayName" FROM "posts" JOIN "comments" ON "posts"."Id" = "comments"."PostId" WHERE "comments"."Score" > 0;	codebase_community
SELECT "Name" FROM "badges" WHERE "UserId" IN (SELECT "Id" FROM "users" WHERE "Location" = 'North Pole') AND strftime('%Y', "Date") = '2011';	codebase_community
SELECT "users"."DisplayName", "users"."WebsiteUrl" FROM "posts" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" WHERE "posts"."FavoriteCount" > 150	codebase_community
SELECT COUNT("Id") AS "PostHistoryCount", MAX("CreationDate") AS "LastEditDate" FROM "postHistory" WHERE "PostId" IN (SELECT "Id" FROM "posts" WHERE "Title" = 'What is the best introductory Bayesian statistics textbook?')	codebase_community
SELECT "users"."LastAccessDate", "users"."Location" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "badges"."Name" = 'outliers';	codebase_community
SELECT "Title" FROM "posts" WHERE "Id" IN (SELECT "RelatedPostId" FROM "postLinks" WHERE "PostId" = (SELECT "Id" FROM "posts" WHERE "Title" = 'How to tell if something happened in a data set which monitors a value over time'))	codebase_community
SELECT "posts"."Id", "badges"."Name" FROM "users" JOIN "badges" ON "users"."Id" = "badges"."UserId" JOIN "posts" ON "users"."Id" = "posts"."OwnerUserId" WHERE "users"."DisplayName" = 'Samuel' AND strftime('%Y', "badges"."Date") = '2013';	codebase_community
SELECT "OwnerDisplayName" FROM "posts" ORDER BY "Score" DESC LIMIT 1	codebase_community
SELECT "users"."DisplayName", "users"."Location" FROM "users" JOIN "posts" ON "users"."Id" = "posts"."OwnerUserId" JOIN "tags" ON "posts"."Id" = "tags"."ExcerptPostId" WHERE "tags"."TagName" = 'hypothesis-testing';	codebase_community
SELECT "relatedPostId", "linkTypeId" FROM "postLinks" JOIN "posts" ON "postLinks"."PostId" = "posts"."Id" WHERE "posts"."Title" = 'What are principal component scores?';	codebase_community
SELECT "OwnerDisplayName" FROM "posts" WHERE "Id" = (SELECT "ParentId" FROM "posts" ORDER BY "Score" DESC LIMIT 1);	codebase_community
SELECT "users"."DisplayName", "users"."WebsiteUrl" FROM "votes" JOIN "users" ON "votes"."UserId" = "users"."Id" WHERE "votes"."VoteTypeId" = 8 ORDER BY "votes"."BountyAmount" DESC LIMIT 1;	codebase_community
SELECT "Title" FROM "posts" ORDER BY "Score" DESC LIMIT 5	codebase_community
SELECT COUNT("Id") FROM "tags" WHERE "Count" BETWEEN 5000 AND 7000;	codebase_community
SELECT "OwnerUserId" FROM "posts" ORDER BY "Score" DESC LIMIT 1	codebase_community
SELECT "Age" FROM "users" ORDER BY "Reputation" DESC LIMIT 1	codebase_community
SELECT COUNT("posts"."Id") FROM "posts" JOIN "votes" ON "posts"."Id" = "votes"."PostId" WHERE "votes"."BountyAmount" = 50 AND strftime('%Y', "posts"."CreaionDate") = '2011';	codebase_community
SELECT "Id" FROM "users" ORDER BY "CreationDate" DESC LIMIT 1	codebase_community
SELECT SUM("Score") FROM "posts" WHERE date("CreaionDate") = '2010-07-19'	codebase_community
SELECT strftime('%Y-%m', "CreationDate") AS "Month", COUNT(*) AS "LinkCount" FROM "postLinks" JOIN "posts" ON "postLinks"."PostId" = "posts"."Id" WHERE strftime('%Y', "CreationDate") = '2010' AND "AnswerCount" <= 2 GROUP BY "Month"	codebase_community
SELECT "PostId" FROM "votes" WHERE "UserId" = 1465 ORDER BY "VoteTypeId" DESC LIMIT 1	codebase_community
SELECT "posts"."Title" FROM "posts" JOIN "postLinks" ON "posts"."Id" = "postLinks"."PostId" ORDER BY "postLinks"."CreationDate" ASC LIMIT 1	codebase_community
SELECT "users"."DisplayName" FROM "users" JOIN "badges" ON "users"."Id" = "badges"."UserId" GROUP BY "users"."Id" ORDER BY COUNT("badges"."Id") DESC LIMIT 1;	codebase_community
SELECT MIN("CreationDate") FROM "votes" WHERE "UserId" = (SELECT "Id" FROM "users" WHERE "DisplayName" = 'chl');	codebase_community
SELECT MIN("CreaionDate") AS "FirstPostDate" FROM "posts" WHERE "OwnerUserId" = (SELECT "Id" FROM "users" ORDER BY "Age" DESC LIMIT 1);	codebase_community
SELECT "users"."DisplayName" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "badges"."Name" = 'Autobiographer' ORDER BY "badges"."Date" ASC LIMIT 1	codebase_community
SELECT COUNT(DISTINCT "users"."Id") AS "UserCount" FROM "users" JOIN "posts" ON "users"."Id" = "posts"."OwnerUserId" WHERE "users"."Location" = 'United Kingdom' AND "posts"."FavoriteCount" >= 4;	codebase_community
SELECT AVG("VoteCount") AS "AverageVotes" FROM (SELECT COUNT("votes"."PostId") AS "VoteCount" FROM "users" JOIN "votes" ON "users"."Id" = "votes"."UserId" GROUP BY "users"."Id" ORDER BY "users"."CreationDate" ASC LIMIT 1);	codebase_community
SELECT "DisplayName" FROM "users" ORDER BY "Reputation" DESC LIMIT 1	codebase_community
SELECT COUNT("Id") FROM "users" WHERE "Reputation" > 2000 AND "Views" > 1000;	codebase_community
SELECT "DisplayName" FROM "users" WHERE "Age" >= 18	codebase_community
SELECT COUNT("posts"."Id") FROM "posts" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" WHERE "users"."DisplayName" = 'Jay Stevens' AND strftime('%Y', "posts"."CreaionDate") = '2010'	codebase_community
SELECT "Id", "Title" FROM "posts" WHERE "OwnerDisplayName" = 'Harvey Motulsky' ORDER BY "ViewCount" DESC LIMIT 1	codebase_community
SELECT "Id", "Title" FROM "posts" ORDER BY "Score" DESC LIMIT 1	codebase_community
SELECT AVG("Score") FROM "posts" WHERE "OwnerDisplayName" = 'Stephen Turner'	codebase_community
SELECT DISTINCT "users"."DisplayName" FROM "users" JOIN "posts" ON "users"."Id" = "posts"."OwnerUserId" WHERE "posts"."ViewCount" > 20000 AND strftime('%Y', "posts"."CreaionDate") = '2011';	codebase_community
SELECT "Id", "OwnerDisplayName" FROM "posts" WHERE strftime('%Y', "CreaionDate") = '2010' ORDER BY "Score" DESC LIMIT 1	codebase_community
SELECT (COUNT("posts"."Id") * 100.0 / (SELECT COUNT("Id") FROM "posts")) AS "Percentage" FROM "posts" JOIN "users" ON "posts"."OwnerUserId" = "users"."Id" WHERE "users"."Reputation" > 1000 AND strftime('%Y', "posts"."CreaionDate") = '2011';	codebase_community
SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM "users") AS "PercentageTeenageUsers" FROM "users" WHERE "Age" BETWEEN 13 AND 19;	codebase_community
SELECT "ViewCount", "LastEditorDisplayName" FROM "posts" WHERE "Title" = 'Computer Game Datasets';	codebase_community
SELECT COUNT("Id") FROM "posts" WHERE "ViewCount" > (SELECT AVG("ViewCount") FROM "posts")	codebase_community
SELECT COUNT("Id") FROM "comments" WHERE "PostId" = (SELECT "Id" FROM "posts" ORDER BY "Score" DESC LIMIT 1)	codebase_community
SELECT COUNT("Id") FROM "posts" WHERE "ViewCount" > 35000 AND "CommentCount" = 0;	codebase_community
SELECT "users"."DisplayName", "users"."Location" FROM "users" JOIN "posts" ON "users"."Id" = "posts"."LastEditorUserId" WHERE "posts"."Id" = 183	codebase_community
SELECT "badges"."Name", "badges"."Date" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "users"."DisplayName" = 'Emmett' ORDER BY "badges"."Date" DESC LIMIT 1	codebase_community
SELECT COUNT("Id") FROM "users" WHERE "Age" >= 18 AND "UpVotes" > 5000;	codebase_community
SELECT "badges"."Date", "users"."CreationDate" FROM "badges" JOIN "users" ON "badges"."UserId" = "users"."Id" WHERE "users"."DisplayName" = 'Zolomon';	codebase_community
SELECT COUNT(DISTINCT "posts"."Id") AS "PostCount", COUNT(DISTINCT "comments"."Id") AS "CommentCount" FROM "users" LEFT JOIN "posts" ON "users"."Id" = "posts"."OwnerUserId" LEFT JOIN "comments" ON "users"."Id" = "comments"."UserId" WHERE "users"."CreationDate" = (SELECT MAX("CreationDate") FROM "users");	codebase_community
SELECT "comments"."Text", "comments"."UserDisplayName" FROM "comments" JOIN "posts" ON "comments"."PostId" = "posts"."Id" WHERE "posts"."Title" = 'Analysing wind data with R' ORDER BY "comments"."CreationDate" DESC LIMIT 10;	codebase_community
SELECT COUNT("UserId") FROM "badges" WHERE "Name" = 'Citizen Patrol'	codebase_community
SELECT COUNT("Id") FROM "posts" WHERE "Tags" LIKE '%careers%'	codebase_community
SELECT "users"."Reputation", "posts"."ViewCount" FROM "users" JOIN "posts" ON "users"."Id" = "posts"."OwnerUserId" WHERE "users"."DisplayName" = 'Jarrod Dixon'	codebase_community
SELECT (SELECT COUNT("Id") FROM "comments" WHERE "PostId" = (SELECT "Id" FROM "posts" WHERE "Title" = 'Clustering 1D data')) AS "CommentCount", (SELECT COUNT("Id") FROM "posts" WHERE "ParentId" = (SELECT "Id" FROM "posts" WHERE "Title" = 'Clustering 1D data')) AS "AnswerCount";	codebase_community
SELECT "CreationDate" FROM "users" WHERE "DisplayName" = 'IrishStat'	codebase_community
SELECT COUNT("Id") FROM "votes" WHERE "BountyAmount" > 30	codebase_community
SELECT (SUM(CASE WHEN "Score" > 50 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS "PercentageAbove50" FROM "posts" WHERE "OwnerUserId" = (SELECT "Id" FROM "users" ORDER BY "Reputation" DESC LIMIT 1);	codebase_community
SELECT COUNT("Id") FROM "posts" WHERE "Score" < 20;	codebase_community
SELECT COUNT("Id") FROM "tags" WHERE "Id" < 15 AND "Count" <= 20;	codebase_community
SELECT "ExcerptPostId", "WikiPostId" FROM "tags" WHERE "TagName" = 'sample'	codebase_community
SELECT "users"."Reputation", "users"."UpVotes" FROM "comments" JOIN "users" ON "comments"."UserId" = "users"."Id" WHERE "comments"."Text" = 'fine, you win :)'	codebase_community
SELECT "Text" FROM "comments" WHERE "PostId" IN (SELECT "Id" FROM "posts" WHERE "Title" LIKE '%linear regression%')	codebase_community
SELECT "Text", "Score" FROM "comments" WHERE "PostId" IN (SELECT "Id" FROM "posts" WHERE "ViewCount" BETWEEN 100 AND 150) ORDER BY "Score" DESC LIMIT 1	codebase_community
SELECT "CreationDate", "Age" FROM "users" WHERE "Id" IN (SELECT "UserId" FROM "comments" WHERE "Text" LIKE '%website%')	codebase_community
SELECT COUNT(DISTINCT "PostId") FROM "comments" WHERE "Score" = 0 AND "PostId" IN (SELECT "Id" FROM "posts" WHERE "ViewCount" < 5);	codebase_community
SELECT COUNT("c"."Id") AS "ZeroScoreComments" FROM "comments" AS "c" JOIN "posts" AS "p" ON "c"."PostId" = "p"."Id" WHERE "p"."CommentCount" = 1 AND "c"."Score" = 0;	codebase_community
SELECT COUNT(DISTINCT "UserId") FROM "comments" WHERE "Score" = 0 AND "UserId" IN (SELECT "Id" FROM "users" WHERE "Age" = 40);	codebase_community
SELECT "posts"."Id", "comments"."Text" FROM "posts" JOIN "comments" ON "posts"."Id" = "comments"."PostId" WHERE "posts"."Title" = 'Group differences on a five point Likert item';	codebase_community
SELECT "users"."UpVotes" FROM "comments" JOIN "users" ON "comments"."UserId" = "users"."Id" WHERE "comments"."Text" = 'R is also lazy evaluated.'	codebase_community
SELECT "Id", "Text", "CreationDate" FROM "comments" WHERE "UserDisplayName" = 'Harvey Motulsky'	codebase_community
SELECT DISTINCT "UserDisplayName" FROM "comments" JOIN "users" ON "comments"."UserId" = "users"."Id" WHERE "comments"."Score" BETWEEN 1 AND 5 AND "users"."DownVotes" = 0;	codebase_community
SELECT COUNT(CASE WHEN "users"."UpVotes" = 0 THEN 1 END) * 100.0 / COUNT(*) AS "Percentage" FROM "comments" JOIN "users" ON "comments"."UserId" = "users"."Id" WHERE "comments"."Score" BETWEEN 5 AND 10;	codebase_community
SELECT "power_name" FROM "superpower" JOIN "hero_power" ON "superpower"."id" = "hero_power"."power_id" JOIN "superhero" ON "hero_power"."hero_id" = "superhero"."id" WHERE "superhero_name" = '3-D Man';	superhero
SELECT COUNT(DISTINCT "superhero"."id") AS "superhero_count" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superpower"."power_name" = 'Super Strength';	superhero
SELECT COUNT(DISTINCT "superhero"."id") FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superpower"."power_name" = 'Super Strength' AND "superhero"."height_cm" > 200;	superhero
SELECT "full_name" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" GROUP BY "superhero"."id" HAVING COUNT("hero_power"."power_id") > 15;	superhero
SELECT COUNT(*) FROM "superhero" WHERE "eye_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'blue');	superhero
SELECT "colour" FROM "colour" WHERE "id" = (SELECT "skin_colour_id" FROM "superhero" WHERE "superhero_name" = 'Apocalypse')	superhero
SELECT COUNT(DISTINCT "superhero"."id") FROM "superhero" JOIN "eye_colour" ON "superhero"."eye_colour_id" = "eye_colour"."id" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "eye_colour"."colour" = 'blue' AND "superpower"."power_name" = 'Agility';	superhero
SELECT "superhero_name" FROM "superhero" WHERE "eye_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'blue') AND "hair_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'blond');	superhero
SELECT COUNT("superhero"."id") FROM "superhero" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" WHERE "publisher"."publisher_name" = 'Marvel Comics';	superhero
SELECT "superhero_name", "height_cm" FROM "superhero" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" WHERE "publisher"."publisher_name" = 'Marvel Comics' ORDER BY "height_cm" DESC;	superhero
SELECT "publisher_name" FROM "publisher" WHERE "id" = (SELECT "publisher_id" FROM "superhero" WHERE "superhero_name" = 'Sauron');	superhero
SELECT "c"."colour", COUNT(*) AS "count" FROM "superhero" AS "s" JOIN "colour" AS "c" ON "s"."eye_colour_id" = "c"."id" JOIN "publisher" AS "p" ON "s"."publisher_id" = "p"."id" WHERE "p"."publisher_name" = 'Marvel Comics' GROUP BY "c"."colour" ORDER BY "count" DESC;	superhero
SELECT AVG("height_cm") FROM "superhero" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" WHERE "publisher"."publisher_name" = 'Marvel Comics';	superhero
SELECT "superhero"."superhero_name", "superhero"."full_name" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" WHERE "publisher"."publisher_name" = 'Marvel Comics' AND "superpower"."power_name" = 'Super Strength';	superhero
SELECT COUNT("id") FROM "superhero" WHERE "publisher_id" = (SELECT "id" FROM "publisher" WHERE "publisher_name" = 'DC Comics');	superhero
SELECT "publisher"."publisher_name" FROM "superhero" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" ORDER BY "superhero"."weight_kg" ASC LIMIT 1;	superhero
SELECT COUNT(DISTINCT "superhero"."id") FROM "superhero" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" WHERE "publisher"."publisher_name" = 'Marvel Comics' AND "superhero"."eye_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'gold');	superhero
SELECT "publisher_name" FROM "publisher" WHERE "id" = (SELECT "publisher_id" FROM "superhero" WHERE "superhero_name" = 'Blue Beetle II');	superhero
SELECT COUNT("superhero"."id") FROM "superhero" JOIN "colour" ON "superhero"."hair_colour_id" = "colour"."id" WHERE "colour"."colour" = 'blonde';	superhero
SELECT "superhero_name" FROM "superhero" WHERE "id" = (SELECT "hero_id" FROM "hero_attribute" WHERE "attribute_id" = (SELECT "id" FROM "attribute" WHERE "attribute_name" = 'Intelligence') ORDER BY "attribute_value" ASC LIMIT 1)	superhero
SELECT "race"."race" FROM "superhero" JOIN "race" ON "superhero"."race_id" = "race"."id" WHERE "superhero"."superhero_name" = 'Copycat';	superhero
SELECT "superhero"."superhero_name", "superhero"."full_name" FROM "superhero" JOIN "hero_attribute" ON "superhero"."id" = "hero_attribute"."hero_id" JOIN "attribute" ON "hero_attribute"."attribute_id" = "attribute"."id" WHERE "attribute"."attribute_name" = 'durability' AND "hero_attribute"."attribute_value" < 50;	superhero
SELECT "superhero_name" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superpower"."power_name" = 'death touch';	superhero
SELECT COUNT(DISTINCT "superhero"."id") FROM "superhero" JOIN "gender" ON "superhero"."gender_id" = "gender"."id" JOIN "hero_attribute" ON "superhero"."id" = "hero_attribute"."hero_id" WHERE "gender"."gender" = 'Female' AND "hero_attribute"."attribute_id" = (SELECT "id" FROM "attribute" WHERE "attribute_name" = 'Strength') AND "hero_attribute"."attribute_value" = 100;	superhero
SELECT "superhero"."superhero_name", COUNT("hero_power"."power_id") AS "power_count" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" GROUP BY "superhero"."superhero_name" ORDER BY "power_count" DESC LIMIT 1;	superhero
SELECT COUNT("superhero"."id") FROM "superhero" JOIN "race" ON "superhero"."race_id" = "race"."id" WHERE "race"."race" = 'vampire';	superhero
SELECT COUNT(CASE WHEN "alignment" = 'self-interest' OR "alignment" = 'moral code' THEN 1 END) * 100.0 / COUNT(*) AS "percentage", COUNT(CASE WHEN "alignment" = 'self-interest' OR "alignment" = 'moral code' AND "publisher_name" = 'Marvel Comics' THEN 1 END) AS "marvel_count" FROM "superhero" JOIN "alignment" ON "superhero"."alignment_id" = "alignment"."id" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id";	superhero
SELECT "publisher_name", COUNT("superhero"."id") AS "superhero_count" FROM "superhero" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" GROUP BY "publisher_name";	superhero
SELECT "publisher_id" FROM "superhero" WHERE "superhero_name" = 'Star Trek'	superhero
SELECT AVG("attribute_value") AS "average_attribute_value" FROM "hero_attribute"	superhero
SELECT COUNT(*) FROM "superhero" WHERE "full_name" IS NULL;	superhero
SELECT "eye_colour_id" FROM "superhero" WHERE "id" = 75	superhero
SELECT "power_name" FROM "superpower" JOIN "hero_power" ON "superpower"."id" = "hero_power"."power_id" JOIN "superhero" ON "hero_power"."hero_id" = "superhero"."id" WHERE "superhero_name" = 'Deathlok';	superhero
SELECT AVG("weight_kg") FROM "superhero" WHERE "gender_id" = (SELECT "id" FROM "gender" WHERE "gender" = 'Female');	superhero
SELECT DISTINCT "superpower"."power_name" FROM "superhero" JOIN "gender" ON "superhero"."gender_id" = "gender"."id" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "gender"."gender" = 'Male' LIMIT 5;	superhero
SELECT "superhero_name" FROM "superhero" WHERE "race_id" = (SELECT "id" FROM "race" WHERE "race" = 'Alien');	superhero
SELECT "superhero_name" FROM "superhero" WHERE "height_cm" BETWEEN 170 AND 190 AND "eye_colour_id" IS NULL;	superhero
SELECT "power_name" FROM "superpower" JOIN "hero_power" ON "superpower"."id" = "hero_power"."power_id" WHERE "hero_power"."hero_id" = 56	superhero
SELECT "full_name" FROM "superhero" WHERE "race_id" IN (SELECT "id" FROM "race" WHERE "race" = 'Demi-God') LIMIT 5;	superhero
SELECT COUNT("superhero"."id") FROM "superhero" JOIN "alignment" ON "superhero"."alignment_id" = "alignment"."id" WHERE "alignment"."alignment" = 'bad';	superhero
SELECT "race"."race" FROM "superhero" JOIN "race" ON "superhero"."race_id" = "race"."id" WHERE "superhero"."weight_kg" = 169;	superhero
SELECT "hair_colour_id" FROM "superhero" WHERE "height_cm" = 185 AND "race_id" = (SELECT "id" FROM "race" WHERE "race" = 'Human');	superhero
SELECT "eye_colour_id" FROM "superhero" WHERE "weight_kg" = (SELECT MAX("weight_kg") FROM "superhero")	superhero
SELECT (COUNT(CASE WHEN "publisher_id" = (SELECT "id" FROM "publisher" WHERE "publisher_name" = 'Marvel Comics') THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM "superhero" WHERE "height_cm" BETWEEN 150 AND 180;	superhero
SELECT "superhero_name" FROM "superhero" JOIN "gender" ON "superhero"."gender_id" = "gender"."id" WHERE "gender"."gender" = 'Male' AND "weight_kg" > (SELECT AVG("weight_kg") * 0.79 FROM "superhero");	superhero
SELECT "power_name", COUNT("power_name") AS "power_count" FROM "superpower" JOIN "hero_power" ON "superpower"."id" = "hero_power"."power_id" GROUP BY "power_name" ORDER BY "power_count" DESC LIMIT 1	superhero
SELECT "attribute_value" FROM "hero_attribute" WHERE "hero_id" = (SELECT "id" FROM "superhero" WHERE "superhero_name" = 'Abomination');	superhero
SELECT "power_name" FROM "superpower" JOIN "hero_power" ON "superpower"."id" = "hero_power"."power_id" WHERE "hero_power"."hero_id" = 1	superhero
SELECT COUNT(DISTINCT "superhero"."id") AS "hero_count" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superpower"."power_name" = 'stealth';	superhero
SELECT "s"."full_name" FROM "superhero" AS "s" JOIN "hero_attribute" AS "ha" ON "s"."id" = "ha"."hero_id" JOIN "attribute" AS "a" ON "ha"."attribute_id" = "a"."id" WHERE "a"."attribute_name" = 'strength' ORDER BY "ha"."attribute_value" DESC LIMIT 1;	superhero
SELECT AVG("height_cm") AS average_height, AVG("weight_kg") AS average_weight FROM "superhero" WHERE "skin_colour_id" IS NULL;	superhero
SELECT COUNT("superhero"."id") FROM "superhero" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" WHERE "publisher"."publisher_name" = 'Dark Horse Comics';	superhero
SELECT "superhero"."superhero_name", MAX("hero_attribute"."attribute_value") AS "max_durability" FROM "superhero" JOIN "hero_attribute" ON "superhero"."id" = "hero_attribute"."hero_id" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" WHERE "publisher"."publisher_name" = 'Dark Horse Comics' AND "hero_attribute"."attribute_id" = (SELECT "id" FROM "attribute" WHERE "attribute_name" = 'Durability') GROUP BY "superhero"."superhero_name" ORDER BY "max_durability" DESC LIMIT 1;	superhero
SELECT "colour" FROM "colour" WHERE "id" = (SELECT "eye_colour_id" FROM "superhero" WHERE "full_name" = 'Abraham Sapien')	superhero
SELECT "superhero"."superhero_name" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superpower"."power_name" = 'flight';	superhero
SELECT "eye_colour_id", "hair_colour_id", "skin_colour_id" FROM "superhero" WHERE "gender_id" = (SELECT "id" FROM "gender" WHERE "gender" = 'Female') AND "publisher_id" = (SELECT "id" FROM "publisher" WHERE "publisher_name" = 'Dark Horse Comics');	superhero
SELECT "s"."superhero_name", "p"."publisher_name" FROM "superhero" AS "s" JOIN "publisher" AS "p" ON "s"."publisher_id" = "p"."id" WHERE "s"."eye_colour_id" = "s"."hair_colour_id" AND "s"."hair_colour_id" = "s"."skin_colour_id";	superhero
SELECT "alignment"."alignment" FROM "superhero" JOIN "alignment" ON "superhero"."alignment_id" = "alignment"."id" WHERE "superhero"."superhero_name" = 'A-Bomb'	superhero
SELECT (COUNT(CASE WHEN "colour"."colour" = 'blue' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM "superhero" JOIN "gender" ON "superhero"."gender_id" = "gender"."id" JOIN "colour" ON "superhero"."eye_colour_id" = "colour"."id" WHERE "gender"."gender" = 'female';	superhero
SELECT "superhero_name", "race"."race" FROM "superhero" JOIN "race" ON "superhero"."race_id" = "race"."id" WHERE "full_name" = 'Charles Chandler';	superhero
SELECT "gender"."gender" FROM "superhero" JOIN "gender" ON "superhero"."gender_id" = "gender"."id" WHERE "superhero"."superhero_name" = 'Agent 13';	superhero
SELECT "superhero"."superhero_name" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superpower"."power_name" = 'adaptation';	superhero
SELECT COUNT("power_id") FROM "hero_power" WHERE "hero_id" = (SELECT "id" FROM "superhero" WHERE "superhero_name" = 'Amazo')	superhero
SELECT "power_name" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superhero_name" = 'Hunter Zolomon';	superhero
SELECT "height_cm" FROM "superhero" WHERE "eye_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'amber');	superhero
SELECT "superhero_name" FROM "superhero" WHERE "eye_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'black') AND "hair_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'black');	superhero
SELECT DISTINCT "colour"."colour" FROM "superhero" JOIN "colour" ON "superhero"."eye_colour_id" = "colour"."id" WHERE "superhero"."skin_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'gold');	superhero
SELECT "full_name" FROM "superhero" WHERE "id" IN (SELECT "hero_id" FROM "hero_attribute" WHERE "attribute_id" = (SELECT "id" FROM "attribute" WHERE "attribute_name" = 'vampire'));	superhero
SELECT "superhero_name" FROM "superhero" JOIN "alignment" ON "superhero"."alignment_id" = "alignment"."id" WHERE "alignment"."alignment" = 'neutral';	superhero
SELECT COUNT(DISTINCT "hero_id") AS "hero_count" FROM "hero_attribute" WHERE "attribute_id" = (SELECT "id" FROM "attribute" WHERE "attribute_name" = 'strength') AND "attribute_value" = (SELECT MAX("attribute_value") FROM "hero_attribute" WHERE "attribute_id" = (SELECT "id" FROM "attribute" WHERE "attribute_name" = 'strength'));	superhero
SELECT "race"."race", "alignment"."alignment" FROM "superhero" JOIN "race" ON "superhero"."race_id" = "race"."id" JOIN "alignment" ON "superhero"."alignment_id" = "alignment"."id" WHERE "superhero"."full_name" = 'Cameron Hicks';	superhero
SELECT (COUNT(CASE WHEN "gender"."gender" = 'Female' AND "publisher"."publisher_name" = 'Marvel Comics' THEN 1 END) * 100.0 / COUNT(CASE WHEN "gender"."gender" = 'Female' THEN 1 END)) AS "percent_female_marvel" FROM "superhero" JOIN "gender" ON "superhero"."gender_id" = "gender"."id" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id";	superhero
SELECT AVG("weight_kg") FROM "superhero" WHERE "race_id" IN (SELECT "id" FROM "race" WHERE "race" = 'Alien');	superhero
SELECT "s1"."weight_kg" - "s2"."weight_kg" AS "weight_difference" FROM "superhero" AS "s1" JOIN "superhero" AS "s2" ON "s1"."id" != "s2"."id" WHERE "s1"."full_name" = 'Emil Blonsky' AND "s2"."full_name" = 'Charles Chandler';	superhero
SELECT "superhero_name", AVG("height_cm") AS "average_height" FROM "superhero" GROUP BY "superhero_name"	superhero
SELECT "power_name" FROM "superpower" JOIN "hero_power" ON "superpower"."id" = "hero_power"."power_id" JOIN "superhero" ON "hero_power"."hero_id" = "superhero"."id" WHERE "superhero_name" = 'Abomination';	superhero
SELECT COUNT(DISTINCT "superhero"."id") AS male_superheroes_count FROM "superhero" JOIN "race" ON "superhero"."race_id" = "race"."id" JOIN "gender" ON "superhero"."gender_id" = "gender"."id" WHERE "race"."race" = 'god/eternal' AND "gender"."gender" = 'male';	superhero
SELECT "superhero_name", "full_name" FROM "superhero" WHERE "id" = (SELECT "hero_id" FROM "hero_attribute" WHERE "attribute_id" = (SELECT "id" FROM "attribute" WHERE "attribute_name" = 'Speed') ORDER BY "attribute_value" DESC LIMIT 1)	superhero
SELECT COUNT("superhero".id) FROM "superhero" JOIN "alignment" ON "superhero".alignment_id = "alignment".id WHERE "alignment".alignment = 'neutral';	superhero
SELECT "attribute"."attribute_name", "hero_attribute"."attribute_value" FROM "hero_attribute" JOIN "superhero" ON "hero_attribute"."hero_id" = "superhero"."id" JOIN "attribute" ON "hero_attribute"."attribute_id" = "attribute"."id" WHERE "superhero"."superhero_name" = '3-D Man';	superhero
SELECT "superhero_name", "full_name" FROM "superhero" WHERE "eye_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'blue') AND "hair_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'brown');	superhero
SELECT "publisher"."publisher_name" FROM "superhero" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" WHERE "superhero"."superhero_name" IN ('Hawkman', 'Karate Kid', 'Speedy');	superhero
SELECT COUNT("id") FROM "superhero" WHERE "publisher_id" IS NULL;	superhero
SELECT (COUNT(CASE WHEN "colour"."colour" = 'blue' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage_blue_eyes" FROM "superhero" JOIN "colour" ON "superhero"."eye_colour_id" = "colour"."id";	superhero
SELECT SUM(CASE WHEN "gender_id" = (SELECT "id" FROM "gender" WHERE "gender" = 'Male') THEN 1 ELSE 0 END) AS male_count, SUM(CASE WHEN "gender_id" = (SELECT "id" FROM "gender" WHERE "gender" = 'Female') THEN 1 ELSE 0 END) AS female_count FROM "superhero";	superhero
SELECT "superhero_name", "height_cm" FROM "superhero" ORDER BY "height_cm" DESC LIMIT 1	superhero
SELECT "id" FROM "superpower" WHERE "power_name" = 'cryokinesis'	superhero
SELECT "superhero_name" FROM "superhero" WHERE "id" = 294;	superhero
SELECT "full_name" FROM "superhero" WHERE "weight_kg" IS NULL;	superhero
SELECT "eye_colour_id" FROM "superhero" WHERE "full_name" = 'Karen Beecher-Duncan'	superhero
SELECT "power_name" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superhero"."full_name" = 'Helen Parr';	superhero
SELECT "race"."race" FROM "superhero" JOIN "race" ON "superhero"."race_id" = "race"."id" WHERE "superhero"."weight_kg" = 108 AND "superhero"."height_cm" = 188;	superhero
SELECT "publisher_name" FROM "publisher" JOIN "superhero" ON "publisher"."id" = "superhero"."publisher_id" WHERE "superhero"."id" = 38;	superhero
SELECT "race"."race" FROM "superhero" JOIN "hero_attribute" ON "superhero"."id" = "hero_attribute"."hero_id" JOIN "race" ON "superhero"."race_id" = "race"."id" WHERE "hero_attribute"."attribute_value" = (SELECT MAX("attribute_value") FROM "hero_attribute");	superhero
SELECT "alignment"."alignment", "superpower"."power_name" FROM "superhero" JOIN "alignment" ON "superhero"."alignment_id" = "alignment"."id" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superhero"."superhero_name" = 'Atom IV';	superhero
SELECT "full_name" FROM "superhero" WHERE "eye_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'blue') LIMIT 5;	superhero
SELECT AVG("attribute_value") FROM "hero_attribute" JOIN "superhero" ON "hero_attribute"."hero_id" = "superhero"."id" JOIN "alignment" ON "superhero"."alignment_id" = "alignment"."id" WHERE "alignment"."alignment" = 'neutral';	superhero
SELECT "skin_colour_id" FROM "hero_attribute" WHERE "attribute_value" = 100	superhero
SELECT COUNT(DISTINCT "superhero"."id") AS good_female_superheroes_count FROM "superhero" JOIN "alignment" ON "superhero"."alignment_id" = "alignment"."id" JOIN "gender" ON "superhero"."gender_id" = "gender"."id" WHERE "alignment"."alignment" = 'good' AND "gender"."gender" = 'female';	superhero
SELECT "superhero"."superhero_name" FROM "superhero" JOIN "hero_attribute" ON "superhero"."id" = "hero_attribute"."hero_id" WHERE "hero_attribute"."attribute_value" BETWEEN 75 AND 80;	superhero
SELECT "race"."race" FROM "superhero" JOIN "gender" ON "superhero"."gender_id" = "gender"."id" JOIN "colour" ON "superhero"."hair_colour_id" = "colour"."id" JOIN "race" ON "superhero"."race_id" = "race"."id" WHERE "gender"."gender" = 'male' AND "colour"."colour" = 'blue';	superhero
SELECT COUNT(CASE WHEN "gender_id" = (SELECT "id" FROM "gender" WHERE "gender" = 'Female') THEN 1 END) * 100.0 / COUNT(*) AS "female_percentage" FROM "superhero" JOIN "alignment" ON "superhero"."alignment_id" = "alignment"."id" WHERE "alignment"."alignment" = 'Bad';	superhero
SELECT (SELECT COUNT(*) FROM "superhero" WHERE "eye_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'blue') AND "weight_kg" IS NULL) - (SELECT COUNT(*) FROM "superhero" WHERE "eye_colour_id" IS NULL AND "weight_kg" IS NULL) AS "difference";	superhero
SELECT "attribute_value" FROM "hero_attribute" WHERE "hero_id" = (SELECT "id" FROM "superhero" WHERE "superhero_name" = 'Hulk') AND "attribute_id" = (SELECT "id" FROM "attribute" WHERE "attribute_name" = 'Strength');	superhero
SELECT "power_name" FROM "superpower" JOIN "hero_power" ON "superpower"."id" = "hero_power"."power_id" JOIN "superhero" ON "hero_power"."hero_id" = "superhero"."id" WHERE "superhero_name" = 'Ajax';	superhero
SELECT COUNT(DISTINCT "superhero"."id") FROM "superhero" JOIN "colour" ON "superhero"."skin_colour_id" = "colour"."id" WHERE "colour"."colour" = 'green' AND "superhero"."alignment_id" IN (SELECT "id" FROM "alignment" WHERE "alignment" = 'villain');	superhero
SELECT COUNT("superhero"."id") FROM "superhero" JOIN "gender" ON "superhero"."gender_id" = "gender"."id" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" WHERE "gender"."gender" = 'Female' AND "publisher"."publisher_name" = 'Marvel Comics';	superhero
SELECT "superhero_name" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superpower"."power_name" = 'control wind' ORDER BY "superhero_name" ASC;	superhero
SELECT "gender"."gender" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" JOIN "gender" ON "superhero"."gender_id" = "gender"."id" WHERE "superpower"."power_name" = 'Phoenix Force';	superhero
SELECT "superhero_name", "weight_kg" FROM "superhero" WHERE "publisher_id" = (SELECT "id" FROM "publisher" WHERE "publisher_name" = 'DC Comics') ORDER BY "weight_kg" DESC LIMIT 1	superhero
SELECT AVG("height_cm") FROM "superhero" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" JOIN "race" ON "superhero"."race_id" = "race"."id" WHERE "publisher"."publisher_name" = 'Dark Horse Comics' AND "race"."race" != 'Human';	superhero
SELECT COUNT(DISTINCT "hero_id") AS "fastest_heroes_count" FROM "hero_attribute" WHERE "attribute_id" = (SELECT "id" FROM "attribute" WHERE "attribute_name" = 'Speed') AND "attribute_value" > 100	superhero
SELECT "publisher_name", COUNT("superhero"."id") AS "superhero_count" FROM "superhero" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" WHERE "publisher_name" IN ('DC', 'Marvel Comics') GROUP BY "publisher_name";	superhero
SELECT "attribute_name", "attribute_value" FROM "hero_attribute" JOIN "superhero" ON "hero_attribute"."hero_id" = "superhero"."id" JOIN "attribute" ON "hero_attribute"."attribute_id" = "attribute"."id" WHERE "superhero_name" = 'Black Panther' ORDER BY "attribute_value" ASC LIMIT 1;	superhero
SELECT "colour" FROM "colour" WHERE "id" = (SELECT "eye_colour_id" FROM "superhero" WHERE "superhero_name" = 'Abomination')	superhero
SELECT "superhero_name" FROM "superhero" ORDER BY "height_cm" DESC LIMIT 1	superhero
SELECT "superhero_name" FROM "superhero" WHERE "full_name" = 'Charles Chandler'	superhero
SELECT (COUNT(CASE WHEN "gender_id" = (SELECT "id" FROM "gender" WHERE "gender" = 'Female') THEN 1 END) * 100.0 / COUNT(*)) AS "female_percentage" FROM "superhero" WHERE "publisher_id" = (SELECT "id" FROM "publisher" WHERE "publisher_name" = 'George Lucas');	superhero
SELECT (SUM(CASE WHEN "alignment" = 'good' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS "good_superhero_percentage" FROM "superhero" JOIN "publisher" ON "superhero"."publisher_id" = "publisher"."id" WHERE "publisher"."publisher_name" = 'Marvel Comics';	superhero
SELECT COUNT(*) FROM "superhero" WHERE "full_name" LIKE 'John%';	superhero
SELECT "hero_id" FROM "hero_attribute" ORDER BY "attribute_value" ASC LIMIT 1	superhero
SELECT "full_name" FROM "superhero" WHERE "superhero_name" = 'Alien';	superhero
SELECT "full_name" FROM "superhero" WHERE "weight_kg" < 100 AND "eye_colour_id" = (SELECT "id" FROM "colour" WHERE "colour" = 'brown');	superhero
SELECT "attribute_value" FROM "hero_attribute" WHERE "hero_id" = (SELECT "id" FROM "superhero" WHERE "superhero_name" = 'Aquababy');	superhero
SELECT "weight_kg", "race_id" FROM "superhero" WHERE "id" = 40	superhero
SELECT AVG("height_cm") FROM "superhero" WHERE "alignment_id" = (SELECT "id" FROM "alignment" WHERE "alignment" = 'neutral');	superhero
SELECT "hero_id" FROM "hero_power" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superpower"."power_name" = 'intelligence';	superhero
SELECT "eye_colour_id" FROM "superhero" WHERE "superhero_name" = 'Blackwulf'	superhero
SELECT "superpower"."power_name" FROM "superhero" JOIN "hero_power" ON "superhero"."id" = "hero_power"."hero_id" JOIN "superpower" ON "hero_power"."power_id" = "superpower"."id" WHERE "superhero"."height_cm" > (SELECT AVG("height_cm") * 0.8 FROM "superhero");	superhero
SELECT "drivers"."driverRef" FROM "qualifying" JOIN "drivers" ON "qualifying"."driverId" = "drivers"."driverId" WHERE "qualifying"."raceId" = 20 AND "qualifying"."position" IS NOT NULL AND "qualifying"."q1" IS NOT NULL AND "qualifying"."q1" != 'NULL';	formula_1
SELECT "drivers"."surname" FROM "qualifying" JOIN "drivers" ON "qualifying"."driverId" = "drivers"."driverId" WHERE "qualifying"."raceId" = 19 AND "qualifying"."q2 IS NOT NULL" ORDER BY "qualifying"."q2" ASC LIMIT 1;	formula_1
SELECT DISTINCT "races"."year" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."location" = 'Shanghai';	formula_1
SELECT "url" FROM "circuits" WHERE "circuitRef" = 'circuit_de_barcelona-catalunya'	formula_1
SELECT "name" FROM "races" WHERE "circuitId" IN (SELECT "circuitId" FROM "circuits" WHERE "country" = 'Germany')	formula_1
SELECT "circuitId", "name" FROM "circuits" JOIN "constructorResults" ON "constructorResults"."raceId" = "races"."raceId" JOIN "constructors" ON "constructorResults"."constructorId" = "constructors"."constructorId" JOIN "races" ON "races"."raceId" = "constructorResults"."raceId" WHERE "constructors"."name" = 'Renault';	formula_1
SELECT COUNT("raceId") FROM "races" WHERE "year" = 2010 AND "circuitId" NOT IN (SELECT "circuitId" FROM "circuits" WHERE "location" IN ('Asia', 'Europe'));	formula_1
SELECT "races"."name" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."country" = 'Spain'	formula_1
SELECT "lat", "lng" FROM "circuits" WHERE "circuitId" IN (SELECT "circuitId" FROM "races" WHERE "name" = 'Australian Grand Prix')	formula_1
SELECT "races"."raceId", "races"."name", "races"."date", "races"."time" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."circuitRef" = 'sepang'	formula_1
SELECT "races"."time" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."circuitRef" = 'sepang';	formula_1
SELECT "lat", "lng" FROM "circuits" WHERE "name" = 'Abu Dhabi Grand Prix'	formula_1
SELECT "nationality" FROM "constructors" WHERE "constructorId" = (SELECT "constructorId" FROM "constructorResults" WHERE "raceId" = 24 AND "points" = 1);	formula_1
SELECT "q1" FROM "qualifying" WHERE "raceId" = 354 AND "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Bruno' AND "surname" = 'Senna')	formula_1
SELECT "drivers"."nationality" FROM "qualifying" JOIN "drivers" ON "qualifying"."driverId" = "drivers"."driverId" WHERE "qualifying"."raceId" = 355 AND "qualifying"."q2" = '0:01:40';	formula_1
SELECT "number" FROM "qualifying" WHERE "raceId" = 903 AND "q3" = '0:01:54';	formula_1
SELECT COUNT("driverId") AS "not_finished" FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "name" = 'Bahrain Grand Prix' AND "year" = 2007) AND "position" = 0;	formula_1
SELECT "year", "url" FROM "seasons" WHERE "year" = (SELECT "year" FROM "races" WHERE "raceId" = 901)	formula_1
SELECT COUNT(DISTINCT "driverId") AS "finished_drivers" FROM "results" WHERE "raceId" IN (SELECT "raceId" FROM "races" WHERE "date" = '2015-11-29');	formula_1
SELECT "drivers"."forename", "drivers"."surname", "drivers"."dob" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "results"."raceId" = 592 ORDER BY "drivers"."dob" ASC LIMIT 1	formula_1
SELECT "drivers"."url" FROM "lapTimes" JOIN "drivers" ON "lapTimes"."driverId" = "drivers"."driverId" WHERE "lapTimes"."raceId" = 161 AND "lapTimes"."time" = '0:01:27';	formula_1
SELECT "drivers"."nationality" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "results"."raceId" = 933 AND "results"."fastestLapSpeed" IS NOT NULL ORDER BY "results"."fastestLapSpeed" DESC LIMIT 1;	formula_1
SELECT "location", "lat", "lng" FROM "circuits" WHERE "circuitId" = (SELECT "circuitId" FROM "races" WHERE "name" = 'Malaysian Grand Prix') LIMIT 1;	formula_1
SELECT "constructors"."url" FROM "constructorStandings" JOIN "constructors" ON "constructorStandings"."constructorId" = "constructors"."constructorId" WHERE "constructorStandings"."raceId" = 9 ORDER BY "constructorStandings"."points" DESC LIMIT 1;	formula_1
SELECT "q1" FROM "qualifying" WHERE "raceId" = 345 AND "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Lucas' AND "surname" = 'di Grassi')	formula_1
SELECT "drivers"."nationality" FROM "qualifying" JOIN "drivers" ON "qualifying"."driverId" = "drivers"."driverId" WHERE "qualifying"."raceId" = 347 AND "qualifying"."q2" = '0:01:15';	formula_1
SELECT "drivers"."code" FROM "qualifying" JOIN "drivers" ON "qualifying"."driverId" = "drivers"."driverId" WHERE "qualifying"."raceId" = 45 AND "qualifying"."q3" = '0:01:33';	formula_1
SELECT "time" FROM "results" WHERE "raceId" = 743 AND "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Bruce' AND "surname" = 'McLaren')	formula_1
SELECT "drivers"."forename", "drivers"."surname" FROM "results" JOIN "races" ON "results"."raceId" = "races"."raceId" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "races"."name" = 'San Marino Grand Prix' AND "races"."year" = 2006 AND "results"."position" = 2;	formula_1
SELECT "year", "url" FROM "seasons" WHERE "year" = (SELECT "year" FROM "races" WHERE "raceId" = 901)	formula_1
SELECT COUNT("resultId") FROM "results" WHERE "raceId" IN (SELECT "raceId" FROM "races" WHERE "date" = '2015-11-29') AND "position" = 0;	formula_1
SELECT "drivers"."forename", "drivers"."surname", "drivers"."dob" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "results"."raceId" = 872 ORDER BY "drivers"."dob" ASC LIMIT 1	formula_1
SELECT "drivers"."forename", "drivers"."surname" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "results"."raceId" = 348 AND "results"."fastestLap" = 1;	formula_1
SELECT "drivers"."nationality" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "results"."fastestLapSpeed" IS NOT NULL ORDER BY "results"."fastestLapSpeed" DESC LIMIT 1	formula_1
SELECT "fastestLapSpeed" FROM "results" WHERE "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Paul' AND "surname" = 'di Resta') AND "raceId" = 853;	formula_1
SELECT "drivers"."driverId", "drivers"."forename", "drivers"."surname", COUNT("results"."resultId") AS "completedRaces", COUNT("results"."resultId") * 1.0 / COUNT("lapTimes"."lap") AS "completionRate" FROM "drivers" JOIN "results" ON "drivers"."driverId" = "results"."driverId" JOIN "races" ON "results"."raceId" = "races"."raceId" LEFT JOIN "lapTimes" ON "results"."raceId" = "lapTimes"."raceId" AND "results"."driverId" = "lapTimes"."driverId" WHERE "races"."date" = '1983-07-16' GROUP BY "drivers"."driverId";	formula_1
SELECT "year" FROM "races" WHERE "circuitId" = (SELECT "circuitId" FROM "circuits" WHERE "circuitRef" = 'singapore') ORDER BY "date" ASC LIMIT 1	formula_1
SELECT "name" FROM "races" WHERE "year" = 2005 ORDER BY "name" DESC;	formula_1
SELECT "name" FROM "races" WHERE "date" = (SELECT MIN("date") FROM "races");	formula_1
SELECT "name", "date" FROM "races" WHERE "year" = 1999 ORDER BY "round" DESC LIMIT 1	formula_1
SELECT "year", COUNT("raceId") AS "race_count" FROM "races" GROUP BY "year" ORDER BY "race_count" DESC LIMIT 1;	formula_1
SELECT "races"."name" FROM "races" WHERE "races"."year" = 2017 AND "races"."raceId" NOT IN (SELECT "races"."raceId" FROM "races" WHERE "races"."year" = 2000);	formula_1
SELECT "name", "location", "country" FROM "circuits" WHERE "circuitId" = (SELECT "circuitId" FROM "races" WHERE "name" = 'European Grand Prix' ORDER BY "date" ASC LIMIT 1)	formula_1
SELECT "year" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."name" = 'Brands Hatch' AND "races"."name" = 'British Grand Prix' ORDER BY "year" DESC LIMIT 1;	formula_1
SELECT COUNT(DISTINCT "races"."year") AS "season_count" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."circuitRef" = 'silverstone' AND "races"."name" = 'British Grand Prix';	formula_1
SELECT "drivers"."forename", "drivers"."surname", "results"."position" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" JOIN "races" ON "results"."raceId" = "races"."raceId" WHERE "races"."year" = 2010 AND "races"."name" = 'Singapore Grand Prix' ORDER BY "results"."position";	formula_1
SELECT "drivers"."forename", "drivers"."surname", SUM("driverStandings"."points") AS "total_points" FROM "driverStandings" JOIN "drivers" ON "driverStandings"."driverId" = "drivers"."driverId" GROUP BY "drivers"."driverId" ORDER BY "total_points" DESC LIMIT 1;	formula_1
SELECT "drivers"."forename", "drivers"."surname", "driverStandings"."points" FROM "driverStandings" JOIN "drivers" ON "driverStandings"."driverId" = "drivers"."driverId" WHERE "driverStandings"."raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2017 AND "name" = 'Chinese Grand Prix') ORDER BY "driverStandings"."points" DESC LIMIT 3;	formula_1
SELECT "drivers"."forename", "drivers"."surname", "races"."name", "lapTimes"."time" FROM "lapTimes" JOIN "drivers" ON "lapTimes"."driverId" = "drivers"."driverId" JOIN "races" ON "lapTimes"."raceId" = "races"."raceId" WHERE "lapTimes"."milliseconds" = (SELECT MIN("milliseconds") FROM "lapTimes");	formula_1
SELECT AVG("milliseconds") AS "average_lap_time" FROM "lapTimes" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "date" = '2009-04-05') AND "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Lewis' AND "surname" = 'Hamilton');	formula_1
SELECT (COUNT(CASE WHEN "circuitId" = 1 AND "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Lewis' AND "surname" = 'Hamilton') THEN 1 END) * 100.0) / COUNT(*) AS "percentage_not_first_track" FROM "races" WHERE "date" >= '2010-01-01';	formula_1
SELECT "drivers"."forename", "drivers"."surname", "drivers"."nationality", MAX("driverStandings"."points") AS "max_points" FROM "driverStandings" JOIN "drivers" ON "driverStandings"."driverId" = "drivers"."driverId" GROUP BY "drivers"."driverId" ORDER BY SUM("driverStandings"."wins") DESC LIMIT 1;	formula_1
SELECT "forename", "surname", (julianday('now') - julianday("dob")) / 365.25 AS "age" FROM "drivers" WHERE "nationality" = 'Japanese' ORDER BY "dob" DESC LIMIT 1	formula_1
SELECT "circuitId", "name", "location", "country" FROM "circuits" JOIN "races" ON "circuits"."circuitId" = "races"."circuitId" WHERE "races"."year" BETWEEN 1990 AND 2000 GROUP BY "circuitId" HAVING COUNT("races"."raceId") = 4;	formula_1
SELECT "circuits"."name", "circuits"."location", "races"."name" FROM "circuits" JOIN "races" ON "circuits"."circuitId" = "races"."circuitId" WHERE "circuits"."country" = 'USA' AND "races"."year" = 2006;	formula_1
SELECT "races"."name", "circuits"."name" AS "circuit_name", "circuits"."location" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "races"."date" BETWEEN '2005-09-01' AND '2005-09-30';	formula_1
SELECT "races"."name" FROM "results" JOIN "races" ON "results"."raceId" = "races"."raceId" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "drivers"."forename" = 'Alex' AND "drivers"."surname" = 'Yoong' AND "results"."grid" < 20;	formula_1
SELECT COUNT("results"."resultId") AS "wins" FROM "results" JOIN "races" ON "results"."raceId" = "races"."raceId" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "drivers"."forename" = 'Michael' AND "drivers"."surname" = 'Schumacher' AND "circuits"."circuitRef" = 'sepang' AND "results"."positionOrder" = 1;	formula_1
SELECT "races"."name", "races"."year" FROM "results" JOIN "races" ON "results"."raceId" = "races"."raceId" WHERE "results"."driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Michael' AND "surname" = 'Schumacher') AND "results"."fastestLap" = 1;	formula_1
SELECT AVG("points") AS "average_points" FROM "driverStandings" JOIN "drivers" ON "driverStandings"."driverId" = "drivers"."driverId" JOIN "races" ON "driverStandings"."raceId" = "races"."raceId" WHERE "drivers"."forename" = 'Eddie' AND "drivers"."surname" = 'Irvine' AND "races"."year" = 2000;	formula_1
SELECT "races"."name", "results"."points" FROM "results" JOIN "races" ON "results"."raceId" = "races"."raceId" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "drivers"."forename" = 'Lewis' AND "drivers"."surname" = 'Hamilton' ORDER BY "races"."date" ASC LIMIT 1;	formula_1
SELECT "races"."date", "circuits"."country" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "races"."year" = 2017 ORDER BY "races"."date";	formula_1
SELECT "races"."name", "races"."year", "circuits"."location" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" ORDER BY "races"."laps" DESC LIMIT 1;	formula_1
SELECT (COUNT(CASE WHEN "country" = 'Germany' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "races"."name" LIKE '%European Grand Prix%';	formula_1
SELECT "lat", "lng" FROM "circuits" WHERE "name" = 'Silverstone Circuit'	formula_1
SELECT "name", "lat" FROM "circuits" WHERE "name" IN ('Silverstone Circuit', 'Hockenheimring', 'Hungaroring')	formula_1
SELECT "circuitRef" FROM "circuits" WHERE "name" = 'Marina Bay Street Circuit'	formula_1
SELECT "country" FROM "circuits" WHERE "alt" = (SELECT MAX("alt") FROM "circuits")	formula_1
SELECT COUNT("driverId") FROM "drivers" WHERE "code" IS NULL;	formula_1
SELECT "nationality" FROM "drivers" ORDER BY "dob" ASC LIMIT 1	formula_1
SELECT "surname" FROM "drivers" WHERE "nationality" = 'Italian'	formula_1
SELECT "url" FROM "drivers" WHERE "forename" = 'Anthony' AND "surname" = 'Davidson'	formula_1
SELECT "driverRef" FROM "drivers" WHERE "forename" = 'Lewis' AND "surname" = 'Hamilton'	formula_1
SELECT "circuitId", "name" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "races"."year" = 2009 AND "races"."name" = 'Spanish Grand Prix';	formula_1
SELECT DISTINCT "races"."year" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."circuitRef" = 'silverstone';	formula_1
SELECT "races"."raceId", "races"."year", "races"."round", "races"."name", "races"."date", "races"."time" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."circuitRef" = 'silverstone';	formula_1
SELECT "time" FROM "races" WHERE "circuitId" = (SELECT "circuitId" FROM "circuits" WHERE "circuitRef" = 'abu_dhabi') AND "year" = 2010;	formula_1
SELECT COUNT("races"."raceId") FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."country" = 'Italy';	formula_1
SELECT DISTINCT "date" FROM "races" WHERE "circuitId" = (SELECT "circuitId" FROM "circuits" WHERE "circuitRef" = 'catalunya');	formula_1
SELECT "url" FROM "circuits" WHERE "circuitId" IN (SELECT "circuitId" FROM "races" WHERE "year" = 2009 AND "name" LIKE '%Spanish Grand Prix%')	formula_1
SELECT "fastestLapTime" FROM "results" WHERE "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Lewis' AND "surname" = 'Hamilton') ORDER BY "milliseconds" ASC LIMIT 1	formula_1
SELECT "drivers"."forename", "drivers"."surname" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" ORDER BY "results"."fastestLapSpeed" DESC LIMIT 1	formula_1
SELECT "drivers"."driverRef" FROM "results" JOIN "races" ON "results"."raceId" = "races"."raceId" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "races"."year" = 2007 AND "races"."name" = 'Canadian Grand Prix' AND "results"."positionOrder" = 1;	formula_1
SELECT DISTINCT "races"."name", "races"."date" FROM "results" JOIN "races" ON "results"."raceId" = "races"."raceId" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "drivers"."forename" = 'Lewis' AND "drivers"."surname" = 'Hamilton'	formula_1
SELECT "races"."name", "races"."date", "results"."position" FROM "results" JOIN "races" ON "results"."raceId" = "races"."raceId" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "drivers"."forename" = 'Lewis' AND "drivers"."surname" = 'Hamilton' ORDER BY "results"."position" ASC LIMIT 1;	formula_1
SELECT "fastestLapSpeed" FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2009 AND "name" = 'Spanish Grand Prix')	formula_1
SELECT DISTINCT "races"."year" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "drivers"."forename" = 'Lewis' AND "drivers"."surname" = 'Hamilton';	formula_1
SELECT "rank" FROM "results" WHERE "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Lewis' AND "surname" = 'Hamilton') AND "raceId" = (SELECT "raceId" FROM "races" WHERE "name" = 'Chinese Grand Prix' AND "year" = 2008);	formula_1
SELECT "drivers"."forename", "drivers"."surname" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" JOIN "races" ON "results"."raceId" = "races"."raceId" WHERE "races"."year" = 1989 AND "races"."name" = 'Australian Grand Prix' AND "results"."grid" = 4;	formula_1
SELECT COUNT(DISTINCT "driverId") FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2008 AND "name" = 'Australian Grand Prix')	formula_1
SELECT "fastestLapTime", "fastestLapSpeed" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" JOIN "races" ON "results"."raceId" = "races"."raceId" WHERE "drivers"."forename" = 'Lewis' AND "drivers"."surname" = 'Hamilton' AND "races"."year" = 2008 AND "races"."name" = 'Australian Grand Prix';	formula_1
SELECT "time" FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2008 AND "name" = 'Australian Grand Prix') AND "positionOrder" = 2	formula_1
SELECT "drivers"."forename", "drivers"."surname", "drivers"."url" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" JOIN "races" ON "results"."raceId" = "races"."raceId" WHERE "races"."year" = 2008 AND "races"."name" = 'Australian Grand Prix' AND "results"."positionOrder" = 1;	formula_1
SELECT COUNT(DISTINCT "drivers"."driverId") AS "driver_count" FROM "drivers" JOIN "results" ON "drivers"."driverId" = "results"."driverId" JOIN "races" ON "results"."raceId" = "races"."raceId" WHERE "races"."year" = 2008 AND "races"."name" = 'Australian Grand Prix' AND "drivers"."nationality" = 'UN';	formula_1
SELECT COUNT(DISTINCT "driverId") FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2008 AND "name" = 'Chinese Grand Prix')	formula_1
SELECT SUM("points") FROM "results" WHERE "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Lewis' AND "surname" = 'Hamilton');	formula_1
SELECT AVG("milliseconds") / 1000.0 AS "average_fastest_lap_time" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "drivers"."forename" = 'Lewis' AND "drivers"."surname" = 'Hamilton';	formula_1
SELECT COUNT(DISTINCT "driverId") AS completed_drivers, (SELECT COUNT(DISTINCT "driverId") FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2008 AND "name" = 'Australian Grand Prix')) AS total_drivers FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2008 AND "name" = 'Australian Grand Prix') AND "laps" = (SELECT "laps" FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2008 AND "name" = 'Australian Grand Prix') LIMIT 1);	formula_1
SELECT (SELECT "time" FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2008 AND "name" = 'Australian Grand Prix') AND "position" = (SELECT MAX("position") FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2008 AND "name" = 'Australian Grand Prix'))) AS "last_driver_time", (SELECT "time" FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2008 AND "name" = 'Australian Grand Prix') AND "position" = 1) AS "champion_time";	formula_1
SELECT COUNT("circuitId") FROM "circuits" WHERE "location" = 'Adelaide' AND "country" = 'Australia';	formula_1
SELECT "name", "lat", "lng" FROM "circuits" WHERE "country" = 'United States'	formula_1
SELECT COUNT("driverId") FROM "drivers" WHERE "nationality" = 'British' AND "dob" > '1980-01-01'	formula_1
SELECT "name", MAX("points") AS "max_points" FROM "constructors" JOIN "constructorResults" ON "constructors"."constructorId" = "constructorResults"."constructorId" WHERE "nationality" = 'British' GROUP BY "name"	formula_1
SELECT "constructors"."name", SUM("constructorResults"."points") AS "total_points" FROM "constructorResults" JOIN "constructors" ON "constructorResults"."constructorId" = "constructors"."constructorId" GROUP BY "constructors"."name" ORDER BY "total_points" DESC LIMIT 1	formula_1
SELECT "constructors"."name" FROM "constructorResults" JOIN "constructors" ON "constructorResults"."constructorId" = "constructors"."constructorId" WHERE "constructorResults"."raceId" = 291 AND "constructorResults"."points" = 0;	formula_1
SELECT COUNT(DISTINCT "constructorId") FROM "constructorResults" cr JOIN "constructors" c ON cr."constructorId" = c."constructorId" WHERE c."nationality" = 'Japanese' AND cr."points" = 0 GROUP BY cr."constructorId" HAVING COUNT(DISTINCT cr."raceId") = 2;	formula_1
SELECT "constructors"."name" FROM "constructorStandings" JOIN "constructors" ON "constructorStandings"."constructorId" = "constructors"."constructorId" WHERE "constructorStandings"."position" = 1;	formula_1
SELECT COUNT(DISTINCT "constructors"."constructorId") FROM "constructors" JOIN "constructorResults" ON "constructors"."constructorId" = "constructorResults"."constructorId" JOIN "results" ON "constructorResults"."raceId" = "results"."raceId" WHERE "constructors"."nationality" = 'French' AND "results"."laps" > 50;	formula_1
SELECT COUNT(DISTINCT "results"."raceId") AS "totalRaces", SUM(CASE WHEN "results"."position" IS NOT NULL THEN 1 ELSE 0 END) AS "completedRaces" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" JOIN "races" ON "results"."raceId" = "races"."raceId" WHERE "drivers"."nationality" = 'Japanese' AND "races"."year" BETWEEN 2007 AND 2009;	formula_1
SELECT "year", AVG("milliseconds") / 1000.0 AS "average_time_seconds" FROM "results" JOIN "driverStandings" ON "results"."raceId" = "driverStandings"."raceId" WHERE "driverStandings"."position" = 1 AND "year" < 1975 GROUP BY "year";	formula_1
SELECT "forename", "surname" FROM "drivers" WHERE "dob" > '1975-01-01' AND "driverId" IN (SELECT "driverId" FROM "driverStandings" WHERE "position" = 2)	formula_1
SELECT COUNT(DISTINCT "drivers"."driverId") AS "count" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "drivers"."nationality" = 'Italian' AND "results"."position" IS NULL;	formula_1
SELECT "drivers"."forename", "drivers"."surname" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" ORDER BY "results"."fastestLapTime" LIMIT 1	formula_1
SELECT "fastestLap" FROM "results" WHERE "raceId" IN (SELECT "raceId" FROM "constructorStandings" WHERE "position" = 1 AND "raceId" IN (SELECT "raceId" FROM "races" WHERE "year" = 2009));	formula_1
SELECT AVG("fastestLapSpeed") FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2009 AND "name" = 'Spanish Grand Prix')	formula_1
SELECT "races"."name", "races"."year" FROM "races" JOIN "results" ON "races"."raceId" = "results"."raceId" ORDER BY "results"."milliseconds" ASC LIMIT 1;	formula_1
SELECT (COUNT(DISTINCT "drivers"."driverId") * 100.0 / (SELECT COUNT(DISTINCT "driverId") FROM "drivers" WHERE "dob" < '1985-01-01')) AS "percentage" FROM "lapTimes" JOIN "drivers" ON "lapTimes"."driverId" = "drivers"."driverId" JOIN "races" ON "lapTimes"."raceId" = "races"."raceId" WHERE "drivers"."dob" < '1985-01-01' AND "lapTimes"."lap" > 50 AND "races"."year" BETWEEN 2000 AND 2005;	formula_1
SELECT COUNT(DISTINCT "drivers"."driverId") AS "FrenchDriverCount" FROM "lapTimes" JOIN "drivers" ON "lapTimes"."driverId" = "drivers"."driverId" WHERE "drivers"."nationality" = 'French' AND "lapTimes"."time" < '02:00.00';	formula_1
SELECT "code" FROM "drivers" WHERE "nationality" = 'American'	formula_1
SELECT "raceId" FROM "races" WHERE "year" = 2009;	formula_1
SELECT COUNT(DISTINCT "driverId") FROM "results" WHERE "raceId" = 18;	formula_1
SELECT "code", "dob" FROM "drivers" ORDER BY "dob" DESC LIMIT 3	formula_1
SELECT "driverRef" FROM "drivers" WHERE "forename" = 'Robert' AND "surname" = 'Kubica'	formula_1
SELECT COUNT("driverId") FROM "drivers" WHERE "nationality" = 'British' AND date("dob") BETWEEN '1980-01-01' AND '1980-12-31';	formula_1
SELECT "drivers"."forename", "drivers"."surname", MIN("lapTimes"."milliseconds") AS "earliestLapTime" FROM "drivers" JOIN "lapTimes" ON "drivers"."driverId" = "lapTimes"."driverId" WHERE "drivers"."nationality" = 'German' AND "drivers"."dob" BETWEEN '1980-01-01' AND '1990-12-31' GROUP BY "drivers"."driverId" ORDER BY "earliestLapTime" ASC LIMIT 3;	formula_1
SELECT "driverRef" FROM "drivers" WHERE "nationality" = 'German' ORDER BY "dob" ASC LIMIT 1	formula_1
SELECT "drivers"."driverId", "drivers"."code" FROM "drivers" JOIN "results" ON "drivers"."driverId" = "results"."driverId" WHERE strftime('%Y', "drivers"."dob") = '1971' AND "results"."fastestLap" = 1;	formula_1
SELECT "d"."forename", "d"."surname", "l"."time" FROM "drivers" AS "d" JOIN "lapTimes" AS "l" ON "d"."driverId" = "l"."driverId" WHERE "d"."nationality" = 'Spanish' AND date("d"."dob") < '1982-01-01' ORDER BY "l"."milliseconds" ASC LIMIT 10;	formula_1
SELECT "races"."year" FROM "results" JOIN "races" ON "results"."raceId" = "races"."raceId" ORDER BY "results"."fastestLapTime" LIMIT 1	formula_1
SELECT "races"."year", AVG("lapTimes"."milliseconds") AS avg_lap_time FROM "lapTimes" JOIN "races" ON "lapTimes"."raceId" = "races"."raceId" GROUP BY "races"."year" ORDER BY avg_lap_time ASC LIMIT 1;	formula_1
SELECT "driverId" FROM "lapTimes" WHERE "lap" = 1 ORDER BY "milliseconds" ASC LIMIT 5;	formula_1
SELECT COUNT(*) AS "disqualifiedFinishers" FROM "results" WHERE "raceId" BETWEEN 50 AND 100 AND "statusId" = (SELECT "statusId" FROM "status" WHERE "status" = 'Disqualified');	formula_1
SELECT "name", "location", "lat", "lng" FROM "circuits" WHERE "country" = 'Austria'	formula_1
SELECT "raceId", COUNT(*) AS "finisherCount" FROM "results" GROUP BY "raceId" ORDER BY "finisherCount" DESC LIMIT 1	formula_1
SELECT "drivers"."driverRef", "drivers"."nationality", "drivers"."dob" FROM "qualifying" JOIN "drivers" ON "qualifying"."driverId" = "drivers"."driverId" WHERE "qualifying"."raceId" = 23 AND "qualifying"."q2" IS NOT NULL;	formula_1
SELECT "drivers"."forename", "drivers"."surname", "races"."year", "races"."date", "races"."time" FROM "drivers" JOIN "qualifying" ON "drivers"."driverId" = "qualifying"."driverId" JOIN "races" ON "qualifying"."raceId" = "races"."raceId" WHERE "drivers"."dob" = (SELECT MIN("dob") FROM "drivers");	formula_1
SELECT COUNT(DISTINCT "drivers"."driverId") AS "AmericanDriverCount" FROM "drivers" JOIN "results" ON "drivers"."driverId" = "results"."driverId" JOIN "constructorResults" ON "results"."raceId" = "constructorResults"."raceId" WHERE "drivers"."nationality" = 'American' AND "constructorResults"."status" = 'puncture';	formula_1
SELECT "constructors"."name", "constructors"."url", MAX("constructorStandings"."points") AS "max_points" FROM "constructors" JOIN "constructorStandings" ON "constructors"."constructorId" = "constructorStandings"."constructorId" WHERE "constructors"."nationality" = 'Italian' GROUP BY "constructors"."name" ORDER BY "max_points" DESC LIMIT 1;	formula_1
SELECT "constructors"."url" FROM "constructors" JOIN "constructorStandings" ON "constructors"."constructorId" = "constructorStandings"."constructorId" GROUP BY "constructors"."constructorId" ORDER BY SUM("constructorStandings"."wins") DESC LIMIT 1;	formula_1
SELECT "drivers"."forename", "drivers"."surname", "lapTimes"."time" FROM "lapTimes" JOIN "drivers" ON "lapTimes"."driverId" = "drivers"."driverId" JOIN "races" ON "lapTimes"."raceId" = "races"."raceId" WHERE "races"."name" = 'French Grand Prix' AND "lapTimes"."lap" = 3 ORDER BY "lapTimes"."milliseconds" DESC LIMIT 1;	formula_1
SELECT "raceId", "fastestLapTime" FROM "results" ORDER BY "fastestLapTime" ASC LIMIT 1	formula_1
SELECT AVG("milliseconds") AS "average_fastest_lap_time" FROM "results" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2006 AND "name" = 'United States Grand Prix') AND "positionOrder" <= 10;	formula_1
SELECT "drivers"."forename", "drivers"."surname", AVG("pitStops"."milliseconds") AS "avgPitStopDuration" FROM "drivers" JOIN "pitStops" ON "drivers"."driverId" = "pitStops"."driverId" WHERE "drivers"."nationality" = 'German' AND "drivers"."dob" BETWEEN '1980-01-01' AND '1985-12-31' GROUP BY "drivers"."driverId" ORDER BY "avgPitStopDuration" ASC LIMIT 3;	formula_1
SELECT "drivers"."forename", "drivers"."surname", "results"."time" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" JOIN "races" ON "results"."raceId" = "races"."raceId" WHERE "races"."year" = 2008 AND "races"."name" = 'Canadian Grand Prix' AND "results"."position" = 1;	formula_1
SELECT "constructors"."constructorRef", "constructors"."url" FROM "results" JOIN "constructors" ON "results"."constructorId" = "constructors"."constructorId" JOIN "races" ON "results"."raceId" = "races"."raceId" WHERE "races"."year" = 2009 AND "races"."name" = 'Singapore Grand Prix' AND "results"."position" = 1;	formula_1
SELECT "forename", "surname", "dob" FROM "drivers" WHERE "nationality" = 'Austrian' AND date("dob") BETWEEN '1981-01-01' AND '1991-12-31'	formula_1
SELECT "forename", "surname", "url", "dob" FROM "drivers" WHERE "nationality" = 'German' AND "dob" BETWEEN '1971-01-01' AND '1985-12-31' ORDER BY "dob" DESC;	formula_1
SELECT "location", "country", "lat", "lng" FROM "circuits" WHERE "circuitRef" = 'hungaroring'	formula_1
SELECT SUM("constructorResults"."points") AS "total_points", "constructors"."name", "constructors"."nationality" FROM "constructorResults" JOIN "races" ON "constructorResults"."raceId" = "races"."raceId" JOIN "constructors" ON "constructorResults"."constructorId" = "constructors"."constructorId" WHERE "races"."name" = 'Monaco Grand Prix' AND "races"."date" BETWEEN '1980-01-01' AND '2010-12-31' GROUP BY "constructors"."constructorId" ORDER BY "total_points" DESC LIMIT 1;	formula_1
SELECT AVG("points") AS average_score FROM "results" JOIN "races" ON "results"."raceId" = "races"."raceId" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "drivers"."forename" = 'Lewis' AND "drivers"."surname" = 'Hamilton' AND "races"."name" = 'Turkish Grand Prix';	formula_1
SELECT COUNT("raceId") * 1.0 / COUNT(DISTINCT "year") AS "average_races_per_year" FROM "races" WHERE "year" BETWEEN 2001 AND 2010;	formula_1
SELECT "nationality", COUNT(*) AS "count" FROM "drivers" GROUP BY "nationality" ORDER BY "count" DESC LIMIT 1	formula_1
SELECT "wins" FROM "driverStandings" WHERE "position" = 91	formula_1
SELECT "races"."name" FROM "results" JOIN "races" ON "results"."raceId" = "races"."raceId" WHERE "results"."fastestLapSpeed" IS NOT NULL ORDER BY "results"."fastestLapSpeed" DESC LIMIT 1	formula_1
SELECT "circuitRef", "location", "country" FROM "circuits" JOIN "races" ON "circuits"."circuitId" = "races"."circuitId" ORDER BY "races"."date" DESC LIMIT 1	formula_1
SELECT "forename", "surname" FROM "drivers" JOIN "qualifying" ON "drivers"."driverId" = "qualifying"."driverId" JOIN "races" ON "qualifying"."raceId" = "races"."raceId" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "qualifying"."position" = 1 AND "qualifying"."number" = 3 AND "circuits"."circuitRef" = 'marina_bay' AND "races"."year" = 2008;	formula_1
SELECT "forename", "surname", "nationality", "name" FROM "drivers" JOIN "results" ON "drivers"."driverId" = "results"."driverId" JOIN "races" ON "results"."raceId" = "races"."raceId" WHERE "dob" = (SELECT MIN("dob") FROM "drivers");	formula_1
SELECT COUNT(*) AS "accident_count" FROM results r JOIN races ra ON r.raceId = ra.raceId WHERE ra.name = 'Canadian Grand Prix' AND r.driverId = (SELECT r2.driverId FROM results r2 JOIN races ra2 ON r2.raceId = ra2.raceId WHERE ra2.name = 'Canadian Grand Prix' GROUP BY r2.driverId ORDER BY COUNT(*) DESC LIMIT 1);	formula_1
SELECT "drivers"."forename", "drivers"."surname", SUM("driverStandings"."wins") AS "total_wins" FROM "drivers" JOIN "driverStandings" ON "drivers"."driverId" = "driverStandings"."driverId" WHERE "drivers"."dob" = (SELECT MIN("dob") FROM "drivers") GROUP BY "drivers"."driverId"	formula_1
SELECT MAX("duration") AS "LongestPitStop" FROM "pitStops"	formula_1
SELECT MIN("milliseconds") AS "fastestLapTime" FROM "lapTimes"	formula_1
SELECT MAX("duration") FROM "pitStops" WHERE "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Lewis' AND "surname" = 'Hamilton');	formula_1
SELECT "lap" FROM "pitStops" WHERE "raceId" = (SELECT "raceId" FROM "races" WHERE "year" = 2011 AND "name" = 'Australian Grand Prix') AND "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Lewis' AND "surname" = 'Hamilton');	formula_1
SELECT "drivers"."forename", "drivers"."surname", "pitStops"."time" FROM "pitStops" JOIN "drivers" ON "pitStops"."driverId" = "drivers"."driverId" JOIN "races" ON "pitStops"."raceId" = "races"."raceId" WHERE "races"."year" = 2011 AND "races"."name" = 'Australian Grand Prix';	formula_1
SELECT "lapTimes"."time" FROM "lapTimes" JOIN "results" ON "lapTimes"."raceId" = "results"."raceId" AND "lapTimes"."driverId" = "results"."driverId" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" WHERE "drivers"."forename" = 'Lewis' AND "drivers"."surname" = 'Hamilton' ORDER BY "lapTimes"."milliseconds" ASC LIMIT 1	formula_1
SELECT "drivers"."forename", "drivers"."surname", MIN("lapTimes"."milliseconds") AS "shortestLapTime" FROM "lapTimes" JOIN "drivers" ON "lapTimes"."driverId" = "drivers"."driverId" GROUP BY "drivers"."driverId" ORDER BY "shortestLapTime" LIMIT 1;	formula_1
SELECT "circuits"."name", "results"."position" FROM "results" JOIN "drivers" ON "results"."driverId" = "drivers"."driverId" JOIN "races" ON "results"."raceId" = "races"."raceId" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "drivers"."forename" = 'Lewis' AND "drivers"."surname" = 'Hamilton' AND "results"."fastestLap" = 1;	formula_1
SELECT "lapTimes"."time" FROM "lapTimes" JOIN "races" ON "lapTimes"."raceId" = "races"."raceId" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."circuitRef" = 'austria' ORDER BY "lapTimes"."milliseconds" ASC LIMIT 1	formula_1
SELECT "circuitId", "name", "location" FROM "circuits" WHERE "country" = 'Italy'	formula_1
SELECT "races"."name" FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."circuitRef" = 'austrian' AND "races"."date" = (SELECT MAX("date") FROM "races" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."circuitRef" = 'austrian');	formula_1
SELECT "pitStops"."duration" FROM "pitStops" JOIN "races" ON "pitStops"."raceId" = "races"."raceId" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."name" = 'Austrian Grand Prix' AND "races"."raceId" IN (SELECT "raceId" FROM "results" WHERE "fastestLap" = 1);	formula_1
SELECT "lat", "lng" FROM "circuits" INNER JOIN "results" ON "circuits"."circuitId" = "results"."circuitId" WHERE "results"."fastestLapTime" = '1:29.488';	formula_1
SELECT AVG("milliseconds") AS "averagePitStopTime" FROM "pitStops" WHERE "driverId" = (SELECT "driverId" FROM "drivers" WHERE "forename" = 'Lewis' AND "surname" = 'Hamilton');	formula_1
SELECT AVG("milliseconds") AS "average_lap_time" FROM "lapTimes" JOIN "races" ON "lapTimes"."raceId" = "races"."raceId" JOIN "circuits" ON "races"."circuitId" = "circuits"."circuitId" WHERE "circuits"."country" = 'Italy';	formula_1
SELECT "player_api_id", "overall_rating" FROM "Player_Attributes" ORDER BY "overall_rating" DESC LIMIT 1	european_football_2
SELECT "player_name", "height" FROM "Player" ORDER BY "height" DESC LIMIT 1	european_football_2
SELECT "preferred_foot" FROM "Player_Attributes" WHERE "potential" = (SELECT MIN("potential") FROM "Player_Attributes");	european_football_2
SELECT COUNT("player_api_id") FROM "Player_Attributes" WHERE "overall_rating" BETWEEN 60 AND 65 AND "attacking_work_rate" = 'High' AND "defensive_work_rate" = 'Low';	european_football_2
SELECT "id" FROM "Player_Attributes" ORDER BY "crossing" DESC LIMIT 5	european_football_2
SELECT "League"."name", SUM("Match"."home_team_goal" + "Match"."away_team_goal") AS total_goals FROM "Match" JOIN "League" ON "Match"."league_id" = "League"."id" WHERE "Match"."season" = '2016' GROUP BY "League"."name" ORDER BY total_goals DESC LIMIT 1;	european_football_2
SELECT "home_team_api_id", COUNT(*) AS "losses" FROM "Match" WHERE "season" = '2016' AND "home_team_goal" < "away_team_goal" GROUP BY "home_team_api_id" ORDER BY "losses" ASC LIMIT 1;	european_football_2
SELECT "player_name" FROM "Player" WHERE "id" IN (SELECT "player_api_id" FROM "Player_Attributes" ORDER BY "penalties" DESC LIMIT 10)	european_football_2
SELECT "away_team_api_id", COUNT(*) AS "away_wins" FROM "Match" WHERE "league_id" IN (SELECT "id" FROM "League" WHERE "name" = 'Scotland Premier League') AND "season" = '2010' AND "away_team_goal" > "home_team_goal" GROUP BY "away_team_api_id" ORDER BY "away_wins" DESC LIMIT 1;	european_football_2
SELECT "Team"."team_long_name", "Team_Attributes"."buildUpPlaySpeed" FROM "Team" JOIN "Team_Attributes" ON "Team"."team_fifa_api_id" = "Team_Attributes"."team_fifa_api_id" ORDER BY "Team_Attributes"."buildUpPlaySpeed" DESC LIMIT 4;	european_football_2
SELECT "League"."name", COUNT(*) AS "draw_count" FROM "Match" JOIN "League" ON "Match"."league_id" = "League"."id" WHERE "Match"."season" = '2016' AND "Match"."home_team_goal" = "Match"."away_team_goal" GROUP BY "League"."name" ORDER BY "draw_count" DESC LIMIT 1;	european_football_2
SELECT date('now') AS CURRENT_DATE, "birthday" FROM "Player" WHERE "id" IN (SELECT "player_api_id" FROM "Player_Attributes" WHERE "sprint_speed" >= 97 AND "date" BETWEEN '2013-01-01' AND '2015-12-31')	european_football_2
SELECT "League"."name", COUNT("Match"."id") AS "match_count" FROM "League" JOIN "Match" ON "League"."id" = "Match"."league_id" GROUP BY "League"."id" ORDER BY "match_count" DESC LIMIT 1;	european_football_2
SELECT AVG("height") FROM "Player" WHERE "birthday" BETWEEN '1990-01-01' AND '1995-12-31'	european_football_2
SELECT "player_api_id" FROM "Player_Attributes" WHERE "date" LIKE '2010%' AND "overall_rating" > (SELECT AVG("overall_rating") FROM "Player_Attributes" WHERE "date" LIKE '2010%');	european_football_2
SELECT "team_fifa_api_id" FROM "Team_Attributes" WHERE "buildUpPlaySpeed" > 50 AND "buildUpPlaySpeed" < 60	european_football_2
SELECT "Team"."team_long_name" FROM "Team" JOIN "Team_Attributes" ON "Team"."team_fifa_api_id" = "Team_Attributes"."team_fifa_api_id" WHERE "Team_Attributes"."date" = '2012' AND "Team_Attributes"."buildUpPlayPassing" > (SELECT AVG("buildUpPlayPassing") FROM "Team_Attributes" WHERE "date" = '2012');	european_football_2
SELECT (COUNT(CASE WHEN "preferred_foot" = 'left' THEN 1 END) * 100.0 / COUNT(*)) AS "percentage_left_foot" FROM "Player_Attributes" WHERE date('1987-01-01') <= "birthday" AND "birthday" <= date('1992-12-31');	european_football_2
SELECT "League"."name", SUM("Match"."home_team_goal" + "Match"."away_team_goal") AS total_goals FROM "League" JOIN "Match" ON "League"."id" = "Match"."league_id" GROUP BY "League"."id" ORDER BY total_goals ASC LIMIT 5;	european_football_2
SELECT AVG("long_shots") FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Ahmed Samir Farag');	european_football_2
SELECT "player_name", AVG("heading_accuracy") AS "avg_heading_accuracy" FROM "Player" JOIN "Player_Attributes" ON "Player"."player_fifa_api_id" = "Player_Attributes"."player_fifa_api_id" WHERE "height" > 180 GROUP BY "player_name" ORDER BY "avg_heading_accuracy" DESC LIMIT 10;	european_football_2
SELECT "Team"."team_long_name", "Team_Attributes"."chanceCreationPassing" FROM "Team" JOIN "Team_Attributes" ON "Team"."team_api_id" = "Team_Attributes"."team_api_id" WHERE "Team_Attributes"."date" = '2014' AND "Team_Attributes"."buildUpPlayDribblingClass" = 'Normal' AND "Team_Attributes"."chanceCreationPassing" < (SELECT AVG("chanceCreationPassing") FROM "Team_Attributes" WHERE "date" = '2014') ORDER BY "Team_Attributes"."chanceCreationPassing" DESC;	european_football_2
SELECT "League"."name" FROM "Match" JOIN "League" ON "Match"."league_id" = "League"."id" WHERE "Match"."season" = '2009/2010' GROUP BY "League"."name" HAVING AVG("Match"."home_team_goal") > AVG("Match"."away_team_goal");	european_football_2
SELECT "team_short_name" FROM "Team" WHERE "team_long_name" = 'Queens Park Rangers'	european_football_2
SELECT "player_name" FROM "Player" WHERE strftime('%Y', "birthday") = '1970' AND strftime('%m', "birthday") = '10';	european_football_2
SELECT "attacking_work_rate" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Franco Zennaro')	european_football_2
SELECT "buildUpPlayPositioningClass" FROM "Team_Attributes" WHERE "team_fifa_api_id" = (SELECT "team_fifa_api_id" FROM "Team" WHERE "team_long_name" = 'ADO Den Haag') AND "date" <= date('now') ORDER BY "date" DESC LIMIT 1	european_football_2
SELECT "heading_accuracy", "finishing" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Francois Affolter') AND "date" = '2014-09-18'	european_football_2
SELECT "overall_rating" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Gabriel Tamas') AND "date" LIKE '2011%';	european_football_2
SELECT COUNT("id") FROM "Match" WHERE "season" = '2015/2016' AND "league_id" IN (SELECT "id" FROM "League" WHERE "name" = 'Scotland Premier League')	european_football_2
SELECT "preferred_foot" FROM "Player_Attributes" WHERE "player_api_id" = (SELECT "player_api_id" FROM "Player" ORDER BY date("birthday") DESC LIMIT 1)	european_football_2
SELECT "player_api_id", "player_name", "potential" FROM "Player_Attributes" WHERE "potential" = (SELECT MAX("potential") FROM "Player_Attributes")	european_football_2
SELECT COUNT(*) FROM "Player_Attributes" WHERE "weight" < 130 AND "preferred_foot" = 'left';	european_football_2
SELECT "Team"."team_short_name" FROM "Team" JOIN "Team_Attributes" ON "Team"."team_fifa_api_id" = "Team_Attributes"."team_fifa_api_id" WHERE "Team_Attributes"."chanceCreationPassingClass" = 'Risky'	european_football_2
SELECT "defensive_work_rate" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'David Wilson')	european_football_2
SELECT "birthday" FROM "Player" WHERE "player_api_id" = (SELECT "player_api_id" FROM "Player_Attributes" ORDER BY "overall_rating" DESC LIMIT 1)	european_football_2
SELECT "name" FROM "League" WHERE "country_id" = (SELECT "id" FROM "Country" WHERE "name" = 'Netherlands')	european_football_2
SELECT AVG("home_team_goal") AS "average_home_goals" FROM "Match" WHERE "season" = '2010/2011' AND "country_id" = (SELECT "id" FROM "Country" WHERE "name" = 'Poland');	european_football_2
SELECT "P1"."player_name", AVG("PA1"."finishing") AS "average_finishing" FROM "Player" AS "P1" JOIN "Player_Attributes" AS "PA1" ON "P1"."player_fifa_api_id" = "PA1"."player_fifa_api_id" WHERE "P1"."height" = (SELECT MAX("height") FROM "Player") OR "P1"."height" = (SELECT MIN("height") FROM "Player") GROUP BY "P1"."player_name" ORDER BY "average_finishing" DESC LIMIT 1;	european_football_2
SELECT "player_name" FROM "Player" WHERE "height" > 180	european_football_2
SELECT COUNT("id") FROM "Player" WHERE "birthday" > '1990-01-01'	european_football_2
SELECT COUNT("id") FROM "Player" WHERE "player_name" LIKE 'Adam%' AND "weight" > 170	european_football_2
SELECT "Player"."player_name" FROM "Player_Attributes" JOIN "Player" ON "Player_Attributes"."player_api_id" = "Player"."player_api_id" WHERE "Player_Attributes"."overall_rating" > 80 AND "Player_Attributes"."date" BETWEEN '2008-01-01' AND '2010-12-31';	european_football_2
SELECT "potential" FROM "Player_Attributes" WHERE "player_api_id" = (SELECT "player_api_id" FROM "Player" WHERE "player_name" = 'Aaron Doran')	european_football_2
SELECT "player_name" FROM "Player" WHERE "preferred_foot" = 'left'	european_football_2
SELECT "Team"."team_long_name" FROM "Team" JOIN "Team_Attributes" ON "Team"."team_fifa_api_id" = "Team_Attributes"."team_fifa_api_id" WHERE "Team_Attributes"."buildUpPlaySpeedClass" = 'Fast'	european_football_2
SELECT "buildUpPlayPassingClass" FROM "Team_Attributes" WHERE "team_api_id" = (SELECT "team_api_id" FROM "Team" WHERE "team_long_name" = 'CLB')	european_football_2
SELECT "Team"."team_short_name" FROM "Team" JOIN "Team_Attributes" ON "Team"."team_fifa_api_id" = "Team_Attributes"."team_fifa_api_id" WHERE "Team_Attributes"."buildUpPlayPassing" > 70;	european_football_2
SELECT AVG("overall_rating") FROM "Player_Attributes" WHERE "date" BETWEEN '2010-01-01' AND '2015-12-31' AND "height" > 170	european_football_2
SELECT "player_name", "height" FROM "Player" ORDER BY "height" ASC LIMIT 1	european_football_2
SELECT "Country"."name" FROM "League" JOIN "Country" ON "League"."country_id" = "Country"."id" WHERE "League"."name" = 'Serie A';	european_football_2
SELECT "Team"."team_short_name" FROM "Team" JOIN "Team_Attributes" ON "Team"."team_api_id" = "Team_Attributes"."team_api_id" WHERE "Team_Attributes"."buildUpPlaySpeed" = 31 AND "Team_Attributes"."buildUpPlayDribbling" = 53 AND "Team_Attributes"."buildUpPlayPassing" = 32;	european_football_2
SELECT AVG("overall_rating") FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Aaron Doran')	european_football_2
SELECT COUNT("id") FROM "Match" JOIN "League" ON "Match"."league_id" = "League"."id" WHERE "League"."name" = 'Germany 1. Bundesliga' AND "Match"."date" BETWEEN '2008-08-01' AND '2008-10-31';	european_football_2
SELECT "Team"."team_short_name" FROM "Match" JOIN "Team" ON "Match"."home_team_api_id" = "Team"."team_api_id" WHERE "Match"."home_team_goal" = 10;	european_football_2
SELECT "player_name" FROM "Player" INNER JOIN "Player_Attributes" ON "Player"."player_fifa_api_id" = "Player_Attributes"."player_fifa_api_id" WHERE "Player_Attributes"."potential" = 61 ORDER BY "Player_Attributes"."balance" DESC LIMIT 1;	european_football_2
SELECT AVG("Player_Attributes"."ball_control") AS "avg_ball_control" FROM "Player_Attributes" JOIN "Player" ON "Player_Attributes"."player_api_id" = "Player"."player_api_id" WHERE "Player"."player_name" IN ('Abdou Diallo', 'Aaron Appindangoye') GROUP BY "Player"."player_name";	european_football_2
SELECT "team_long_name" FROM "Team" WHERE "team_short_name" = 'GEN'	european_football_2
SELECT "player_name", "birthday" FROM "Player" WHERE "player_name" IN ('Aaron Lennon', 'Abdelaziz Barrada')	european_football_2
SELECT "player_name", "height" FROM "Player" ORDER BY "height" DESC LIMIT 1	european_football_2
SELECT COUNT(*) FROM Player_Attributes WHERE "preferred_foot" = 'left' AND "attacking_work_rate" = 'medium';	european_football_2
SELECT "Country"."name" FROM "League" JOIN "Country" ON "League"."country_id" = "Country"."id" WHERE "League"."name" = 'Jupiler League';	european_football_2
SELECT "name" FROM "League" WHERE "country_id" = (SELECT "id" FROM "Country" WHERE "name" = 'Germany')	european_football_2
SELECT "player_api_id", "player_name", "overall_rating" FROM "Player_Attributes" ORDER BY "strength" DESC LIMIT 1	european_football_2
SELECT COUNT(*) FROM Player_Attributes WHERE "date" < '1986-01-01' AND "defensive_work_rate" = 'Medium' AND "attacking_work_rate" = 'Low';	european_football_2
SELECT "player_name", "crossing" FROM "Player_Attributes" WHERE "player_fifa_api_id" IN (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" IN ('Alexis', 'Ariel Borysiuk', 'Arouna Kone')) ORDER BY "crossing" DESC LIMIT 1	european_football_2
SELECT "heading_accuracy" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Ariel Borysiuk')	european_football_2
SELECT COUNT("id") FROM "Player" JOIN "Player_Attributes" ON "Player"."id" = "Player_Attributes"."player_api_id" WHERE "Player"."height" > 180 AND "Player_Attributes"."volleys" > 70;	european_football_2
SELECT "player_name" FROM "Player_Attributes" WHERE "volleys" > 70 AND "dribbling" > 70	european_football_2
SELECT COUNT("id") FROM "Match" WHERE "season" = '2008/2009' AND "country_id" = (SELECT "id" FROM "Country" WHERE "name" = 'Belgium');	european_football_2
SELECT "long_passing" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" ORDER BY "birthday" ASC LIMIT 1)	european_football_2
SELECT COUNT("id") FROM "Match" WHERE "league_id" = (SELECT "id" FROM "League" WHERE "name" = 'Jupiler League' AND "country_id" = (SELECT "id" FROM "Country" WHERE "name" = 'Belgium')) AND "date" BETWEEN '2009-04-01' AND '2009-04-30';	european_football_2
SELECT "League"."name", COUNT("Match"."id") AS match_count FROM "Match" JOIN "League" ON "Match"."league_id" = "League"."id" WHERE "Match"."season" = '2008/2009' GROUP BY "League"."name" ORDER BY match_count DESC LIMIT 1;	european_football_2
SELECT AVG("overall_rating") FROM "Player_Attributes" WHERE "player_fifa_api_id" IN (SELECT "player_fifa_api_id" FROM "Player" WHERE date("birthday") < '1986-01-01')	european_football_2
SELECT (SELECT "overall_rating" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Ariel Borysiuk') ORDER BY "date" DESC LIMIT 1) AS "Ariel_Borysiuk_Rating", (SELECT "overall_rating" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Paulin Puel') ORDER BY "date" DESC LIMIT 1) AS "Paulin_Puel_Rating";	european_football_2
SELECT AVG("buildUpPlaySpeed") FROM "Team_Attributes" WHERE "team_api_id" IN (SELECT "id" FROM "Team" WHERE "team_long_name" = 'Heart of Midlothian');	european_football_2
SELECT AVG("overall_rating") FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Pietro Marino');	european_football_2
SELECT "crossing" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Aaron Lennox')	european_football_2
SELECT "chanceCreationPassing", "chanceCreationPassingClass" FROM "Team_Attributes" WHERE "team_fifa_api_id" = (SELECT "team_fifa_api_id" FROM "Team" WHERE "team_long_name" = 'Ajax') ORDER BY "chanceCreationPassing" DESC LIMIT 1	european_football_2
SELECT "preferred_foot" FROM "Player_Attributes" WHERE "player_api_id" = (SELECT "player_api_id" FROM "Player" WHERE "player_name" = 'Abdou Diallo')	european_football_2
SELECT MAX("overall_rating") FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Dorlan Pabon')	european_football_2
SELECT AVG("away_team_goal") AS "average_goals" FROM "Match" JOIN "Team" ON "Match"."away_team_api_id" = "Team"."team_api_id" WHERE "Match"."country_id" = (SELECT "id" FROM "Country" WHERE "name" = 'Italy') AND "Team"."team_long_name" = 'Parma';	european_football_2
SELECT "player_name" FROM "Player" INNER JOIN "Player_Attributes" ON "Player"."player_fifa_api_id" = "Player_Attributes"."player_fifa_api_id" WHERE "Player_Attributes"."overall_rating" = 77 AND "Player_Attributes"."date" = '2016-06-23' ORDER BY "birthday" ASC LIMIT 1;	european_football_2
SELECT "overall_rating" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Aaron Mooy') AND "date" = '2016-02-04'	european_football_2
SELECT "potential" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Francesco Parravicini') AND "date" = '2010-08-30'	european_football_2
SELECT "attacking_work_rate" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Francesco Migliore') AND "date" = '2015-05-01'	european_football_2
SELECT "defensive_work_rate" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Kevin Berigaud') AND "date" = '2013-02-22'	european_football_2
SELECT "date" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Kevin Constant') AND "crossing" = (SELECT MAX("crossing") FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Kevin Constant'));	european_football_2
SELECT "Team_Attributes"."buildUpPlaySpeedClass" FROM "Team_Attributes" JOIN "Team" ON "Team_Attributes"."team_api_id" = "Team"."team_api_id" WHERE "Team"."team_long_name" = 'Willem II' AND "Team_Attributes"."date" = '2011-02-22'	european_football_2
SELECT "buildUpPlayDribblingClass" FROM "Team_Attributes" WHERE "team_fifa_api_id" = (SELECT "team_fifa_api_id" FROM "Team" WHERE "team_short_name" = 'LEI') AND "date" = '2015-09-10'	european_football_2
SELECT "buildUpPlayPassingClass" FROM "Team_Attributes" ta JOIN "Team" t ON ta."team_api_id" = t."team_api_id" WHERE t."team_long_name" = 'FC Lorient' AND ta."date" = '2010-02-22'	european_football_2
SELECT "Team_Attributes"."chanceCreationPassingClass" FROM "Team_Attributes" JOIN "Team" ON "Team_Attributes"."team_api_id" = "Team"."team_api_id" WHERE "Team"."team_long_name" = 'PEC Zwolle' AND "Team_Attributes"."date" = '2013/9/20';	european_football_2
SELECT "chanceCreationCrossingClass" FROM "Team_Attributes" ta JOIN "Team" t ON ta."team_api_id" = t."team_api_id" WHERE t."team_long_name" = 'Hull City' AND ta."date" = '2010-02-22'	european_football_2
SELECT "defenceAggressionClass" FROM "Team_Attributes" WHERE "team_fifa_api_id" = (SELECT "team_fifa_api_id" FROM "Team" WHERE "team_long_name" = 'Hannover 96') AND "date" = '2015-09-10'	european_football_2
SELECT AVG("overall_rating") FROM "Player_Attributes" WHERE "player_api_id" = (SELECT "player_api_id" FROM "Player" WHERE "player_name" = 'Marko Arnautovic') AND "date" BETWEEN '2007-02-22' AND '2016-04-21';	european_football_2
SELECT (SELECT "overall_rating" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Landon Donovan') AND "date" = '2013-07-12') AS "donovan_rating", (SELECT "overall_rating" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Jordan Bowery') AND "date" = '2013-07-12') AS "bowery_rating";	european_football_2
SELECT "player_name" FROM "Player" ORDER BY "height" DESC LIMIT 10	european_football_2
SELECT "player_api_id" FROM "Player" ORDER BY "weight" DESC LIMIT 10	european_football_2
SELECT "player_name" FROM "Player" WHERE date('now') - "birthday" >= 35 * 365.25	european_football_2
SELECT SUM("home_team_goal") FROM "Match" WHERE "home_player_X1" = (SELECT "id" FROM "Player" WHERE "player_name" = 'Aaron Lennon') OR "home_player_X2" = (SELECT "id" FROM "Player" WHERE "player_name" = 'Aaron Lennon') OR "home_player_X3" = (SELECT "id" FROM "Player" WHERE "player_name" = 'Aaron Lennon') OR "home_player_X4" = (SELECT "id" FROM "Player" WHERE "player_name" = 'Aaron Lennon') OR "home_player_X5" = (SELECT "id" FROM "Player" WHERE "player_name" = 'Aaron Lennon') OR "home_player_X6" = (SELECT "id" FROM "Player" WHERE "player_name" = 'Aaron Lennon') OR "home_player_X7" = (SELECT "id" FROM "Player" WHERE "player_name" = 'Aaron Lennon') OR "home_player_X8" = (SELECT "id" FROM "Player" WHERE "player_name" = 'Aaron Lennon') OR "home_player_X9" = (SELECT "id" FROM "Player" WHERE "player_name" = 'Aaron Lennon') OR "home_player_X10" = (SELECT "id" FROM "Player" WHERE "player_name" = 'Aaron Lennon') OR "home_player_X11" = (SELECT "id" FROM "Player" WHERE "player_name" = 'Aaron Lennon');	european_football_2
SELECT SUM("away_team_goal") FROM "Match" WHERE "away_team_api_id" IN (SELECT "player_api_id" FROM "Player" WHERE "player_name" IN ('Daan Smith', 'Filipe Ferreira'));	european_football_2
SELECT SUM("home_team_goal") FROM "Match" WHERE "home_team_api_id" IN (SELECT "player_api_id" FROM "Player" WHERE date('now') - "birthday" <= 30 * 365);	european_football_2
SELECT "player_name" FROM "Player" ORDER BY "strength" DESC LIMIT 1	european_football_2
SELECT "player_name" FROM "Player" WHERE "id" = (SELECT "player_api_id" FROM "Player_Attributes" ORDER BY "potential" DESC LIMIT 1)	european_football_2
SELECT "player_name" FROM "Player" WHERE "id" IN (SELECT "player_fifa_api_id" FROM "Player_Attributes" WHERE "attacking_work_rate" = 'High')	european_football_2
SELECT "player_name" FROM "Player" JOIN "Player_Attributes" ON "Player"."player_fifa_api_id" = "Player_Attributes"."player_fifa_api_id" WHERE "Player_Attributes"."finishing" = 1 ORDER BY "birthday" ASC LIMIT 1	european_football_2
SELECT "player_name" FROM "Player" WHERE "player_api_id" IN (SELECT "id" FROM "Team" WHERE "team_short_name" = 'BEL')	european_football_2
SELECT "country"."name" FROM "Player_Attributes" JOIN "Player" ON "Player_Attributes"."player_api_id" = "Player"."player_api_id" JOIN "Team" ON "Player"."player_fifa_api_id" = "Team"."team_fifa_api_id" JOIN "Match" ON "Match"."home_player_1" = "Player"."id" OR "Match"."away_player_1" = "Player"."id" JOIN "Country" ON "Match"."country_id" = "Country"."id" WHERE "Player_Attributes"."vision" >= 90;	european_football_2
SELECT "Country"."name", AVG("Player"."weight") AS "average_weight" FROM "Player" JOIN "Player_Attributes" ON "Player"."player_api_id" = "Player_Attributes"."player_api_id" JOIN "Match" ON "Player_Attributes"."player_fifa_api_id" = "Match"."home_player_1" OR "Player_Attributes"."player_fifa_api_id" = "Match"."away_player_1" JOIN "League" ON "Match"."league_id" = "League"."id" JOIN "Country" ON "League"."country_id" = "Country"."id" GROUP BY "Country"."name" ORDER BY "average_weight" DESC LIMIT 1;	european_football_2
SELECT "team_long_name" FROM "Team_Attributes" WHERE "buildUpPlaySpeedClass" = 'Slow'	european_football_2
SELECT "team_short_name" FROM "Team_Attributes" WHERE "chanceCreationPassingClass" = 'Safe'	european_football_2
SELECT AVG("height") AS average_height FROM "Player" WHERE "player_api_id" IN (SELECT "id" FROM "Team" WHERE "team_fifa_api_id" IN (SELECT "team_api_id" FROM "Match" WHERE "country_id" = (SELECT "id" FROM "Country" WHERE "name" = 'Italy')))	european_football_2
SELECT "player_name" FROM "Player" WHERE "height" > 180 ORDER BY "player_name" LIMIT 3;	european_football_2
SELECT COUNT("id") FROM "Player" WHERE "birthday" > '1999-12-31' AND "player_name" LIKE 'Aaron%';	european_football_2
SELECT "jumping" FROM "Player_Attributes" WHERE "player_api_id" IN (6, 23)	european_football_2
SELECT "id" FROM "Player_Attributes" WHERE "potential" = (SELECT MIN("potential") FROM "Player_Attributes") AND "preferred_foot" = 'Right' ORDER BY "overall_rating" ASC LIMIT 5;	european_football_2
SELECT COUNT("player_api_id") FROM "Player_Attributes" WHERE "crossing" = (SELECT MAX("crossing") FROM "Player_Attributes") AND "preferred_foot" = 'left' AND "attacking_work_rate" = 'high';	european_football_2
SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM "Player")) AS "percentage" FROM "Player_Attributes" WHERE "strength" > 80 AND "stamina" > 80;	european_football_2
SELECT "Country"."name" FROM "League" JOIN "Country" ON "League"."country_id" = "Country"."id" WHERE "League"."name" = 'Ekstraklasa' AND "Country"."name" = 'Poland';	european_football_2
SELECT "home_team_goal", "away_team_goal" FROM "Match" WHERE "date" = '2008-09-24' AND "league_id" IN (SELECT "id" FROM "League" WHERE "name" = 'Jupiler League' AND "country_id" IN (SELECT "id" FROM "Country" WHERE "name" = 'Belgium'));	european_football_2
SELECT "sprint_speed", "agility", "acceleration" FROM "Player_Attributes" WHERE "player_fifa_api_id" = (SELECT "player_fifa_api_id" FROM "Player" WHERE "player_name" = 'Alexis Blin')	european_football_2
SELECT "buildUpPlaySpeedClass" FROM "Team_Attributes" WHERE "team_fifa_api_id" = (SELECT "team_fifa_api_id" FROM "Team" WHERE "team_long_name" = 'KSV Cercle Brugge')	european_football_2
SELECT COUNT("id") FROM "Match" WHERE "season" = '2015–2016' AND "league_id" IN (SELECT "id" FROM "League" WHERE "name" = 'Serie A' AND "country_id" IN (SELECT "id" FROM "Country" WHERE "name" = 'Italy'));	european_football_2
SELECT MAX("home_team_goal") FROM "Match" WHERE "league_id" = (SELECT "id" FROM "League" WHERE "name" = 'Eredivisie' AND "country_id" = (SELECT "id" FROM "Country" WHERE "name" = 'Netherlands'));	european_football_2
SELECT "finishing", "curve" FROM "Player_Attributes" WHERE "player_api_id" = (SELECT "player_api_id" FROM "Player" ORDER BY "weight" DESC LIMIT 1)	european_football_2
SELECT "League"."name", COUNT("Match"."id") AS "game_count" FROM "Match" JOIN "League" ON "Match"."league_id" = "League"."id" WHERE "Match"."season" = '2015-2016' GROUP BY "League"."name" ORDER BY "game_count" DESC LIMIT 4;	european_football_2
SELECT "Team"."team_long_name" FROM "Match" JOIN "Team" ON "Match"."away_team_api_id" = "Team"."team_api_id" ORDER BY "Match"."away_team_goal" DESC LIMIT 1;	european_football_2
SELECT "player_api_id", "overall_rating" FROM "Player_Attributes" ORDER BY "strength" DESC LIMIT 1	european_football_2
SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM "Player" WHERE "height" < 180) AS "percentage" FROM "Player_Attributes" WHERE "strength" > 70 AND "player_api_id" IN (SELECT "player_api_id" FROM "Player" WHERE "height" < 180);	european_football_2
SELECT COUNT(CASE WHEN "Admission" = 'in-patient' AND "SEX" = 'male' THEN 1 END) AS "InPatientMale", COUNT(CASE WHEN "Admission" = 'outpatient' AND "SEX" = 'male' THEN 1 END) AS "OutPatientMale" FROM "Patient"	thrombosis_prediction
SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM "Patient")) AS "Percentage" FROM "Patient" WHERE "SEX" = 'female' AND "Birthday" > '1930-01-01';	thrombosis_prediction
SELECT (SUM(CASE WHEN "Admission" = 'Inpatient' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS "Inpatient_Percentage" FROM "Patient" WHERE "Birthday" BETWEEN '1930-01-01' AND '1940-12-31';	thrombosis_prediction
SELECT COUNT(CASE WHEN "Admission" = 'Outpatient' THEN 1 END) AS "Outpatient_Count", COUNT(CASE WHEN "Admission" = 'Inpatient' THEN 1 END) AS "Inpatient_Count" FROM "Patient" WHERE "Diagnosis" = 'SLE';	thrombosis_prediction
SELECT "Patient"."Diagnosis", "Laboratory"."Date" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."ID" = 30609;	thrombosis_prediction
SELECT "Patient"."SEX", "Patient"."Birthday", "Examination"."Examination Date", "Examination"."Symptoms" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Patient"."ID" = 163109;	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."SEX", "Patient"."Birthday" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."LDH" > 250	thrombosis_prediction
SELECT "Patient"."ID", (strftime('%Y', 'now') - strftime('%Y', "Patient"."Birthday")) AS "Age" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Examination"."Thrombosis" = 1;	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."SEX", "Patient"."Diagnosis" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Examination"."Thrombosis" = 3	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE strftime('%Y', "Patient"."Birthday") = '1937' AND "Laboratory"."T-CHO" > 200	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."SEX", "Patient"."Diagnosis" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."ALB" < 3.5	thrombosis_prediction
SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Patient WHERE "SEX" = 'Female')) AS "Percentage" FROM Patient JOIN Laboratory ON Patient."ID" = Laboratory."ID" WHERE Laboratory."TP" < 6.0 OR Laboratory."TP" > 8.0 AND Patient."SEX" = 'Female';	thrombosis_prediction
SELECT AVG("aCL IgG") AS "Average aCL IgG" FROM "Examination" JOIN "Patient" ON "Examination"."ID" = "Patient"."ID" WHERE (julianday('now') - julianday("Birthday")) / 365.25 >= 50;	thrombosis_prediction
SELECT COUNT("Patient"."ID") FROM "Patient" WHERE "SEX" = 'female' AND strftime('%Y', "First Date") = '1997' AND "Admission" = 'outpatient clinic';	thrombosis_prediction
SELECT MIN(strftime('%Y', 'now')) - MIN(strftime('%Y', "Birthday")) AS "Age" FROM "Patient"	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Examination"."Thrombosis" = 1 AND strftime('%Y', "Examination"."Examination Date") = '1997' AND "Patient"."SEX" = 'F';	thrombosis_prediction
SELECT MAX(strftime('%Y', 'now')) - MIN(strftime('%Y', "Birthday")) AS age_gap FROM Patient JOIN Laboratory ON Patient.ID = Laboratory.ID WHERE "TG" < 150;	thrombosis_prediction
SELECT "Symptoms", "Diagnosis" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Birthday" = (SELECT MIN("Birthday") FROM "Patient")	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") / 12.0 AS "AverageMalePatients" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'male' AND "Laboratory"."Date" BETWEEN '1998-01-01' AND '1998-12-31';	thrombosis_prediction
SELECT "Laboratory"."Date", (julianday("Patient"."First Date") - julianday("Patient"."Birthday")) / 365.25 AS "Age" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."Diagnosis" = 'SJS' ORDER BY "Laboratory"."Date" ASC LIMIT 1	thrombosis_prediction
SELECT SUM(CASE WHEN "SEX" = 'Male' THEN 1 ELSE 0 END) AS "Male_Count", SUM(CASE WHEN "SEX" = 'Female' THEN 1 ELSE 0 END) AS "Female_Count" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "UA" > 7;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" WHERE "Patient"."First Date" <= date('now', '-1 year') AND "Patient"."ID" NOT IN (SELECT "Examination"."ID" FROM "Examination");	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Patient"."Birthday" > date('1990-01-01', '-18 years') AND "Examination"."Examination Date" BETWEEN '1990-01-01' AND '1993-12-31';	thrombosis_prediction
SELECT COUNT("Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'male' AND "Laboratory"."T-BIL" > 1.2	thrombosis_prediction
SELECT "Diagnosis", COUNT("Diagnosis") AS "Count" FROM "Patient" WHERE "ID" IN (SELECT "ID" FROM "Laboratory" WHERE "Date" BETWEEN '1985-01-01' AND '1995-12-31') GROUP BY "Diagnosis" ORDER BY "Count" DESC LIMIT 1;	thrombosis_prediction
SELECT AVG(strftime('%Y', date('now')) - strftime('%Y', "Birthday")) AS "Average Age" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."Date" BETWEEN '1991-10-01' AND '1991-10-31' AND strftime('%Y', "Examination Date") = '1999';	thrombosis_prediction
SELECT "Patient"."Birthday", "Patient"."Diagnosis" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."HGB" = (SELECT MAX("HGB") FROM "Laboratory");	thrombosis_prediction
SELECT "ANA" FROM "Examination" WHERE "ID" = 3605340 AND "Examination Date" = '1996-12-02';	thrombosis_prediction
SELECT "T-CHO" FROM "Laboratory" WHERE "ID" = 2927464 AND "Date" = '1995-09-04'	thrombosis_prediction
SELECT "SEX" FROM "Patient" WHERE "Diagnosis" = 'AORTITIS' ORDER BY "First Date" LIMIT 1	thrombosis_prediction
SELECT "aCL IgG", "aCL IgM", "aCL IgA" FROM "Examination" JOIN "Patient" ON "Examination"."ID" = "Patient"."ID" WHERE "Patient"."Diagnosis" = 'SLE' AND "Patient"."First Date" = '1994-02-19' AND "Examination Date" = '1993-11-12';	thrombosis_prediction
SELECT "SEX" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."Date" = '1992-06-12' AND "Laboratory"."GPT" = 9;	thrombosis_prediction
SELECT date('1991-10-21') - "Birthday" AS age FROM Patient JOIN Laboratory ON Patient.ID = Laboratory.ID WHERE "UA" = 8.4 AND "Date" = '1991-10-21';	thrombosis_prediction
SELECT COUNT("ID") FROM "Laboratory" WHERE "Date" BETWEEN '1995-01-01' AND '1995-12-31' AND "ID" IN (SELECT "ID" FROM "Patient" WHERE "First Date" = '1991-06-13' AND "Diagnosis" = 'SJS');	thrombosis_prediction
SELECT "Diagnosis" FROM "Patient" WHERE "ID" = (SELECT "ID" FROM "Patient" WHERE "Diagnosis" = 'SLE' AND "First Date" = '1997-01-27');	thrombosis_prediction
SELECT "Symptoms" FROM "Examination" JOIN "Patient" ON "Examination"."ID" = "Patient"."ID" WHERE "Patient"."Birthday" = '1959-03-01' AND "Examination Date" = '1993-09-27';	thrombosis_prediction
SELECT L1."T-CHO" AS "November_TCHO", L2."T-CHO" AS "December_TCHO", ((L1."T-CHO" - L2."T-CHO") / L1."T-CHO") * 100 AS "Decrease_Rate" FROM Patient P JOIN Laboratory L1 ON P."ID" = L1."ID" AND L1."Date" = '1981-11-01' JOIN Laboratory L2 ON P."ID" = L2."ID" AND L2."Date" = '1981-12-01' WHERE P."Birthday" = '1959-02-18';	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Patient"."Diagnosis" = 'Behcet''s' AND "Examination"."Examination Date" BETWEEN '1970-01-01' AND '1997-12-31';	thrombosis_prediction
SELECT DISTINCT "Patient"."ID" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Examination Date" BETWEEN '1987-07-06' AND '1996-01-31' AND "GPT" > 30 AND "ALB" < 4;	thrombosis_prediction
SELECT "ID" FROM "Patient" WHERE "SEX" = 'female' AND strftime('%Y', "Birthday") = '1964' AND "Admission" IS NOT NULL;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Examination"."Thrombosis" = 2 AND "Examination"."ANA Pattern" = 'S' AND "Examination"."aCL IgM" > (SELECT AVG("aCL IgM") * 1.2 FROM "Examination");	thrombosis_prediction
SELECT (COUNT(CASE WHEN "UA" < 0.5 THEN 1 END) * 100.0 / COUNT(*)) AS "Percentage" FROM "Laboratory" WHERE "UN" BETWEEN 0 AND 150;	thrombosis_prediction
SELECT (COUNT(CASE WHEN "Diagnosis" = 'BEHCET' THEN 1 END) * 100.0 / COUNT(*)) AS "Percentage" FROM "Patient" WHERE "SEX" = 'male' AND strftime('%Y', "First Date") = '1981';	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."Date" BETWEEN '1991-10-01' AND '1991-10-31' AND "Laboratory"."T-BIL" < 1.2;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Patient"."SEX" = 'F' AND "Patient"."Birthday" BETWEEN '1980-01-01' AND '1989-12-31' AND "Examination"."ANA Pattern" != 'P';	thrombosis_prediction
SELECT "Patient"."SEX" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Examination"."Diagnosis" = 'PSS' AND "Laboratory"."CRP" = '2+' AND "Laboratory"."CRE" = 1 AND "Laboratory"."LDH" = 123;	thrombosis_prediction
SELECT AVG("ALB") FROM "Laboratory" JOIN "Patient" ON "Laboratory"."ID" = "Patient"."ID" WHERE "Patient"."SEX" = 'female' AND "Laboratory"."PLT" > 400 AND "Patient"."Diagnosis" = 'SLE';	thrombosis_prediction
SELECT "Symptoms" FROM "Examination" WHERE "Diagnosis" = 'SLE' GROUP BY "Symptoms" ORDER BY COUNT(*) DESC LIMIT 1	thrombosis_prediction
SELECT "First Date", "Diagnosis" FROM "Patient" WHERE "ID" = 48473	thrombosis_prediction
SELECT COUNT("Patient"."ID") FROM "Patient" WHERE "Patient"."SEX" = 'female' AND "Patient"."Diagnosis" = 'APS';	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."Date" BETWEEN '1997-01-01' AND '1997-12-31' AND ("Laboratory"."TP" < 6.0 OR "Laboratory"."TP" > 8.0 OR "Laboratory"."ALB" < 3.5 OR "Laboratory"."ALB" > 5.0 OR "Laboratory"."UA" < 2.0 OR "Laboratory"."UA" > 7.0 OR "Laboratory"."CRE" < 0.6 OR "Laboratory"."CRE" > 1.2 OR "Laboratory"."T-BIL" < 0.1 OR "Laboratory"."T-BIL" > 1.2 OR "Laboratory"."T-CHO" < 150 OR "Laboratory"."T-CHO" > 200 OR "Laboratory"."TG" < 40 OR "Laboratory"."TG" > 150 OR "Laboratory"."WBC" < 4.0 OR "Laboratory"."WBC" > 10.0 OR "Laboratory"."RBC" < 4.0 OR "Laboratory"."RBC" > 6.0 OR "Laboratory"."HGB" < 12.0 OR "Laboratory"."HGB" > 16.0 OR "Laboratory"."HCT" < 36.0 OR "Laboratory"."HCT" > 50.0 OR "Laboratory"."PLT" < 150 OR "Laboratory"."PLT" > 450 OR "Laboratory"."PT" < 11.0 OR "Laboratory"."PT" > 13.0 OR "Laboratory"."APTT" < 30 OR "Laboratory"."APTT" > 40.0 OR "Laboratory"."FG" < 200 OR "Laboratory"."FG" > 400);	thrombosis_prediction
SELECT COUNT(CASE WHEN "Diagnosis" = 'SLE' THEN 1 END) * 1.0 / COUNT(*) AS "Proportion" FROM Patient WHERE "ID" IN (SELECT "ID" FROM Examination WHERE "Symptoms" LIKE '%thrombocytopenia%');	thrombosis_prediction
SELECT (COUNT(CASE WHEN "SEX" = 'F' THEN 1 END) * 100.0 / COUNT(*)) AS "Percentage" FROM "Patient" WHERE strftime('%Y', "Birthday") = '1980' AND "Diagnosis" = 'RA';	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Patient"."SEX" = 'male' AND "Patient"."First Date" BETWEEN '1995-01-01' AND '1997-12-31' AND "Patient"."Diagnosis" = 'Behcet disease' AND "Patient"."Admission" = 'no';	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "FemalePatientsWithLowWBC" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'female' AND "Laboratory"."WBC" < 3.5;	thrombosis_prediction
SELECT "Examination Date", "First Date" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Patient"."ID" = 821298	thrombosis_prediction
SELECT "UA" FROM "Laboratory" WHERE "ID" = 57266	thrombosis_prediction
SELECT "Date" FROM "Laboratory" WHERE "ID" = 48473 AND "GOT" > 40	thrombosis_prediction
SELECT "Patient"."SEX", "Patient"."Birthday" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."Date" BETWEEN '1994-01-01' AND '1994-12-31' AND "Laboratory"."GOT" BETWEEN 0 AND 40;	thrombosis_prediction
SELECT DISTINCT "Patient"."ID" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'male' AND "Laboratory"."GPT" > 40;	thrombosis_prediction
SELECT "Patient"."Diagnosis" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."GPT" > 40 ORDER BY "Patient"."Birthday" ASC;	thrombosis_prediction
SELECT AVG("LDH") FROM "Laboratory" WHERE "LDH" BETWEEN 140 AND 280	thrombosis_prediction
SELECT "Patient"."ID", (strftime('%Y', 'now') - strftime('%Y', "Patient"."Birthday")) AS "Age" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."LDH" BETWEEN 100 AND 300;	thrombosis_prediction
SELECT "Patient"."Admission" FROM "Laboratory" JOIN "Patient" ON "Laboratory"."ID" = "Patient"."ID" WHERE "Laboratory"."ALP" BETWEEN 30 AND 120	thrombosis_prediction
SELECT "Patient"."ID", "Laboratory"."ALP" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."Birthday" = '1982-04-01';	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."SEX", "Patient"."Birthday" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."TP" < 6.0	thrombosis_prediction
SELECT "Patient"."ID", "Laboratory"."TP" - 7.0 AS "TP_Deviation" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'female' AND "Laboratory"."TP" > 7.0;	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."Birthday" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'male' AND ("Laboratory"."ALB" < 3.5 OR "Laboratory"."ALB" > 5.0) ORDER BY "Patient"."Birthday" DESC;	thrombosis_prediction
SELECT "Patient"."ID", "Laboratory"."ALB" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE strftime('%Y', "Patient"."Birthday") = '1982' AND "Laboratory"."ALB" BETWEEN 3.5 AND 5.0	thrombosis_prediction
SELECT (COUNT(CASE WHEN "UA" > 7 THEN 1 END) * 100.0 / COUNT(*)) AS "Percentage" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'Female';	thrombosis_prediction
SELECT AVG("UA") AS "Average_UA" FROM "Laboratory" WHERE "ID" IN (SELECT "ID" FROM "Laboratory" AS L1 WHERE "Date" = (SELECT MAX("Date") FROM "Laboratory" AS L2 WHERE L1."ID" = L2."ID")) AND "UA" IS NOT NULL AND "UA" < 7;	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."SEX", "Patient"."Birthday" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."UN" BETWEEN 7 AND 20;	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."SEX", "Patient"."Birthday" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."Diagnosis" = 'RA' AND "Laboratory"."UN" BETWEEN 0 AND 1	thrombosis_prediction
SELECT COUNT("Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'male' AND ("Laboratory"."CRE" < 0.7 OR "Laboratory"."CRE" > 1.3);	thrombosis_prediction
SELECT COUNT(CASE WHEN "SEX" = 'Male' AND "CRE" NOT BETWEEN 0.6 AND 1.2 THEN 1 END) AS "Male_Count", COUNT(CASE WHEN "SEX" = 'Female' AND "CRE" NOT BETWEEN 0.6 AND 1.2 THEN 1 END) AS "Female_Count" FROM Patient JOIN Laboratory ON Patient.ID = Laboratory.ID;	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."SEX", "Patient"."Birthday" FROM "Laboratory" JOIN "Patient" ON "Laboratory"."ID" = "Patient"."ID" WHERE "Laboratory"."T-BIL" = (SELECT MAX("T-BIL") FROM "Laboratory");	thrombosis_prediction
SELECT "Patient"."SEX", COUNT(*) AS "Count" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."T-BIL" < 1.2 OR "Laboratory"."T-BIL" > 2.0 GROUP BY "Patient"."SEX";	thrombosis_prediction
SELECT "Patient"."ID", "Laboratory"."T-CHO" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" ORDER BY "Patient"."Birthday" ASC, "Laboratory"."T-CHO" DESC LIMIT 1	thrombosis_prediction
SELECT AVG(strftime('%Y', 'now') - strftime('%Y', "Birthday")) AS "Average Age" FROM "Patient" WHERE "SEX" = 'male' AND "Diagnosis" LIKE '%high cholesterol%';	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."Diagnosis" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."TG" > 100;	thrombosis_prediction
SELECT COUNT("Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."TG" > 150 AND (julianday('now') - julianday("Patient"."Birthday")) / 365.25 > 50;	thrombosis_prediction
SELECT DISTINCT "Patient"."ID" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."CPK" BETWEEN 0 AND 200	thrombosis_prediction
SELECT COUNT("Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."Birthday" BETWEEN '1936-01-01' AND '1956-12-31' AND "Laboratory"."CPK" > 200 AND "Patient"."SEX" = 'Male';	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."SEX", (strftime('%Y', 'now') - strftime('%Y', "Patient"."Birthday")) AS "AGE" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."GLU" NOT BETWEEN 70 AND 100 AND "Laboratory"."T-CHO" BETWEEN 125 AND 200;	thrombosis_prediction
SELECT "Patient"."ID", "Laboratory"."GLU" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."First Date" LIKE '1991%' AND "Laboratory"."GLU" BETWEEN 70 AND 100;	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."SEX", "Patient"."Birthday" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."WBC" < 4 OR "Laboratory"."WBC" > 10 ORDER BY "Patient"."Birthday" ASC;	thrombosis_prediction
SELECT "Patient"."ID", strftime('%Y', 'now') - strftime('%Y', "Patient"."Birthday") AS "Age", "Patient"."Diagnosis" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."RBC" < (SELECT AVG("RBC") FROM "Laboratory");	thrombosis_prediction
SELECT "Patient"."Admission" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'female' AND (julianday('now') - julianday("Patient"."Birthday")) / 365.25 >= 50 AND "Laboratory"."RBC" < 4.0 OR "Laboratory"."RBC" > 6.0;	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."SEX" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."HGB" < 13	thrombosis_prediction
SELECT "Patient"."ID", "Patient"."SEX" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."Diagnosis" = 'SLE' AND "Laboratory"."HGB" >= 13 ORDER BY "Patient"."Birthday" ASC LIMIT 1;	thrombosis_prediction
SELECT "Patient"."ID", (strftime('%Y', 'now') - strftime('%Y', "Patient"."Birthday")) AS "Age" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."HCT" > 45 GROUP BY "Patient"."ID" HAVING COUNT("Laboratory"."ID") >= 2;	thrombosis_prediction
SELECT AVG("HCT") FROM "Laboratory" WHERE "Date" LIKE '1991%' AND "HCT" < 40	thrombosis_prediction
SELECT SUM(CASE WHEN "PLT" < 150 THEN 1 ELSE 0 END) AS "Lower_Than_Normal", SUM(CASE WHEN "PLT" > 450 THEN 1 ELSE 0 END) AS "Higher_Than_Normal" FROM "Laboratory" WHERE "PLT" < 150 OR "PLT" > 450;	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."Date" BETWEEN '1984-01-01' AND '1984-12-31' AND (julianday('now') - julianday("Patient"."Birthday")) / 365.25 < 50 AND "Laboratory"."PLT" BETWEEN 150 AND 450;	thrombosis_prediction
SELECT COUNT(CASE WHEN "SEX" = 'female' THEN 1 END) * 100.0 / COUNT(*) AS "Percentage" FROM "Patient" WHERE DATE('now') - "Birthday" > 55 * 365;	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."First Date" > '1992-12-31' AND "Laboratory"."PT" BETWEEN 11 AND 13.5;	thrombosis_prediction
SELECT COUNT(*) FROM "Examination" WHERE "Examination Date" > '1997-01-01' AND "KCT" = 'inactivated partial prothrombin time';	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "No_Thrombosis_Count" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."APTT" > 35 AND "Patient"."Diagnosis" IS NULL;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "Count" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'male' AND "Laboratory"."WBC" = 7.0 AND "Laboratory"."FG" > 400;	thrombosis_prediction
SELECT COUNT("Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."Birthday" > '1980-01-01' AND "Laboratory"."FG" > 400;	thrombosis_prediction
SELECT DISTINCT "Diagnosis" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "UA" > 0.3	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."U-PRO" = 'normal' AND "Patient"."Diagnosis" = 'SLE';	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "PatientCount" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Examination"."aCL IgG" > 0;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "PatientCount" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Examination"."aCL IgG" = 0 AND "Examination"."Symptoms" IS NOT NULL;	thrombosis_prediction
SELECT "Patient"."Diagnosis" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Examination"."aCL IgA" = (SELECT MAX("Examination"."aCL IgA") FROM "Examination" WHERE "Examination"."aCL IgA" <= 1.0);	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Examination"."aCL IgA" = 0 AND "Patient"."First Date" > '1990-01-01';	thrombosis_prediction
SELECT "Diagnosis", COUNT(*) AS "Count" FROM "Examination" WHERE "aCL IgM" > 1 GROUP BY "Diagnosis" ORDER BY "Count" DESC LIMIT 1;	thrombosis_prediction
SELECT COUNT("Patient"."ID") FROM "Patient" LEFT JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."CRP" = 'abnormal' AND "Laboratory"."ID" IS NULL;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."CRE" > 1.2 AND (julianday('now') - julianday("Patient"."Birthday")) / 365 < 70	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Patient"."RF" = 'normal' AND "Examination"."Thrombosis" = 1;	thrombosis_prediction
SELECT DISTINCT "Patient"."Diagnosis" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."Birthday" > '1985-01-01' AND "Laboratory"."RF" = 'normal';	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."RF" = 'normal' AND (julianday('now') - julianday("Patient"."Birthday")) / 365 > 60;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" WHERE "Patient"."Diagnosis" = 'normal RF' AND "Patient"."ID" NOT IN (SELECT "Examination"."ID" FROM "Examination" WHERE "Examination"."Thrombosis" = 1);	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Patient"."Diagnosis" = 'normal' AND "Examination"."ANA Pattern" = 'P' AND "Patient"."Diagnosis" = 'normal' AND "Patient"."ID" IN (SELECT "Laboratory"."ID" FROM "Laboratory" WHERE "Laboratory"."C3" = 0);	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "HCT" NOT BETWEEN 36 AND 50 ORDER BY "aCL IgG" DESC LIMIT 1;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "NormalComplement4Count" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Examination"."Thrombosis" = 1 AND "Laboratory"."C4" = 0;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" WHERE "Patient"."Admission" = 'Yes' AND "Patient"."Diagnosis" = 'Normal level of anti-ribonuclear protein';	thrombosis_prediction
SELECT "Birthday" FROM "Patient" WHERE "ID" IN (SELECT "ID" FROM "Laboratory" WHERE "RNP" = 'abnormal') ORDER BY "Birthday" DESC LIMIT 1	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "No_Thrombosis_Count" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Examination"."ANA" = 0 AND "Examination"."Thrombosis" = 0;	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."SM" = 'abnormal' ORDER BY "Patient"."Birthday" DESC LIMIT 3;	thrombosis_prediction
SELECT DISTINCT "Patient"."ID" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Examination Date" > '1997-01-01' AND "ANA" = 0;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "FemaleWithoutSymptomsCount" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Patient"."SEX" = 'female' AND "Examination"."ANA" = 0 AND "Examination"."Symptoms" IS NULL;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."SSA" = 'normal' AND "Patient"."First Date" < '2000-01-01';	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" WHERE "Patient"."Diagnosis" LIKE '%abnormal anti-SSA%' ORDER BY "Patient"."First Date" ASC LIMIT 1;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."Diagnosis" = "Examination"."Diagnosis" WHERE "Examination"."ANA" = 0 AND "Examination"."Diagnosis" = 'SLE';	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Patient"."Description" = 'normal' AND "Examination"."Symptoms" IS NOT NULL;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "MalePatientCount" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" WHERE "Examination"."ANA" = 0 AND "Examination"."ANA Pattern" = 'normal' AND "Patient"."SEX" = 'male';	thrombosis_prediction
SELECT DISTINCT "Diagnosis" FROM "Patient" WHERE "ID" IN (SELECT "ID" FROM "Laboratory" WHERE "DNA-II" > 0)	thrombosis_prediction
SELECT COUNT("Patient"."ID") FROM "Patient" LEFT JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."DNA" IS NULL OR "Laboratory"."DNA" = 0	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."IGG" = 0;	thrombosis_prediction
SELECT (COUNT(CASE WHEN "GOT" > 40 THEN 1 END) * 100.0 / COUNT(*)) AS "Percentage" FROM "Laboratory" JOIN "Patient" ON "Laboratory"."ID" = "Patient"."ID" WHERE "Patient"."Diagnosis" = 'SLE';	thrombosis_prediction
SELECT COUNT("Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'male' AND "Laboratory"."GOT" BETWEEN 0 AND 40;	thrombosis_prediction
SELECT MIN("Birthday") FROM "Patient" WHERE "ID" IN (SELECT "ID" FROM "Laboratory" WHERE "GOT" > 40);	thrombosis_prediction
SELECT "Patient"."Birthday" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."GPT" BETWEEN 0 AND 40 ORDER BY "Laboratory"."GPT" DESC LIMIT 3;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "MaleCount" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."GPT" = 0 AND "Patient"."SEX" = 'Male';	thrombosis_prediction
SELECT "Patient"."First Date" FROM "Laboratory" JOIN "Patient" ON "Laboratory"."ID" = "Patient"."ID" WHERE "Laboratory"."LDH" = (SELECT MAX("LDH") FROM "Laboratory" WHERE "LDH" < 500) LIMIT 1;	thrombosis_prediction
SELECT MAX("Date") FROM "Laboratory" WHERE "LDH" > 250	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Laboratory" JOIN "Patient" ON "Laboratory"."ID" = "Patient"."ID" WHERE "Laboratory"."ALP" > 120 AND "Patient"."Admission" = 'Yes';	thrombosis_prediction
SELECT COUNT("Patient"."ID") AS "NormalAlkPhosCount" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."ALP" BETWEEN 30 AND 120;	thrombosis_prediction
SELECT "Patient"."Diagnosis" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."TP" < 6.0	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "Normal_Protein_Count" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."Diagnosis" = 'SJS' AND "Laboratory"."TP" BETWEEN 6.0 AND 8.3;	thrombosis_prediction
SELECT "Examination Date" FROM "Examination" JOIN "Laboratory" ON "Examination".ID = "Laboratory".ID WHERE "ALB" = (SELECT MAX("ALB") FROM "Laboratory")	thrombosis_prediction
SELECT COUNT("Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'male' AND "Laboratory"."ALB" >= 3.5 AND "Laboratory"."TP" >= 6.0;	thrombosis_prediction
SELECT "aCL IgG" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."SEX" = 'female' AND "Laboratory"."UA" = (SELECT MAX("UA") FROM "Laboratory" WHERE "UA" IS NOT NULL) AND "Laboratory"."UA" < 7.0;	thrombosis_prediction
SELECT MAX("ANA") FROM "Examination" WHERE "ID" IN (SELECT "ID" FROM "Patient" WHERE "Diagnosis" = 'normal') AND "ID" IN (SELECT "ID" FROM "Laboratory" WHERE "CRE" = 0);	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."CRE" BETWEEN 0.6 AND 1.2 ORDER BY "Examination"."aCL IgG" DESC LIMIT 1;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."T-BIL" > 1.2 AND "Examination"."ANA Pattern" = 'Peripheral';	thrombosis_prediction
SELECT "ANA" FROM "Examination" WHERE "ID" = (SELECT "ID" FROM "Laboratory" WHERE "T-BIL" = (SELECT MAX("T-BIL") FROM "Laboratory" WHERE "T-BIL" <= 1.2))	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "Count" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."T-CHO" > 200 AND "Laboratory"."PT" < 12	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."T-CHO" BETWEEN 0 AND 200 AND "Examination"."ANA Pattern" = 'P';	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."TG" < 150 AND "Patient"."Symptoms" IS NOT NULL;	thrombosis_prediction
SELECT "Patient"."Diagnosis" FROM "Laboratory" JOIN "Patient" ON "Laboratory"."ID" = "Patient"."ID" WHERE "Laboratory"."TG" = (SELECT MAX("TG") FROM "Laboratory" WHERE "TG" <= 150);	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Examination"."Thrombosis" = 0 AND "Laboratory"."CPK" > 200;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."CRE" BETWEEN 0.0 AND 200.0 AND "Laboratory"."CPK" > 200;	thrombosis_prediction
SELECT "Birthday" FROM "Patient" WHERE "ID" IN (SELECT "ID" FROM "Laboratory" WHERE "GLU" > 140) ORDER BY "Birthday" LIMIT 1	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "No_Thrombosis_Count" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."GLU" = 70 AND "Patient"."Diagnosis" IS NULL;	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "NormalWBCCount" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."WBC" BETWEEN 4.0 AND 10.0 AND "Patient"."Admission" = 'accepted';	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Patient"."Diagnosis" = 'SLE' AND "Laboratory"."WBC" BETWEEN 4 AND 11;	thrombosis_prediction
SELECT "Patient"."ID" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."RBC" < 4.0 OR "Laboratory"."RBC" > 6.0 AND "Patient"."Admission" = 'outpatient clinic';	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") AS "Normal_Platelet_Patients_With_Symptoms" FROM "Patient" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Laboratory"."PLT" BETWEEN 150 AND 450 AND "Patient"."Admission" IS NOT NULL;	thrombosis_prediction
SELECT "PLT" FROM "Laboratory" WHERE "PLT" BETWEEN 150 AND 450 AND "ID" IN (SELECT "ID" FROM "Patient" WHERE "Diagnosis" = 'MCTD');	thrombosis_prediction
SELECT AVG("PT") FROM "Laboratory" WHERE "PT" = 1 AND "ID" IN (SELECT "ID" FROM "Patient" WHERE "SEX" = 'male');	thrombosis_prediction
SELECT COUNT(DISTINCT "Patient"."ID") FROM "Patient" JOIN "Examination" ON "Patient"."ID" = "Examination"."ID" JOIN "Laboratory" ON "Patient"."ID" = "Laboratory"."ID" WHERE "Examination"."Thrombosis" = 1 AND "Laboratory"."PT" = 100;	thrombosis_prediction
SELECT "major"."major_name" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "member"."first_name" = 'Angela' AND "member"."last_name" = 'Sanders';	student_club
SELECT COUNT(DISTINCT "member_id") FROM "member" WHERE "link_to_major" IN (SELECT "major_id" FROM "major" WHERE "college" = 'College of Engineering')	student_club
SELECT "first_name", "last_name" FROM "member" WHERE "link_to_major" IN (SELECT "major_id" FROM "major" WHERE "department" = 'Art and Design')	student_club
SELECT COUNT(DISTINCT "link_to_member") FROM "attendance" JOIN "event" ON "attendance"."link_to_event" = "event"."event_id" WHERE "event"."event_name" = 'Women''s Soccer';	student_club
SELECT "m"."phone" FROM "member" AS "m" JOIN "attendance" AS "a" ON "m"."member_id" = "a"."link_to_member" JOIN "event" AS "e" ON "a"."link_to_event" = "e"."event_id" WHERE "e"."event_name" = 'Women''s Soccer';	student_club
SELECT COUNT(DISTINCT "link_to_member") AS "medium_tshirt_count" FROM "attendance" a JOIN "event" e ON a."link_to_event" = e."event_id" JOIN "member" m ON a."link_to_member" = m."member_id" WHERE e."event_name" = 'Women''s Soccer' AND m."t_shirt_size" = 'Medium';	student_club
SELECT "event"."event_name" FROM "event" JOIN "attendance" ON "event"."event_id" = "attendance"."link_to_event" GROUP BY "event"."event_id" ORDER BY COUNT("attendance"."link_to_member") DESC LIMIT 1	student_club
SELECT "college" FROM "member" WHERE "position" = 'Vice President'	student_club
SELECT "event"."event_name" FROM "event" JOIN "attendance" ON "event"."event_id" = "attendance"."link_to_event" JOIN "member" ON "attendance"."link_to_member" = "member"."member_id" WHERE "member"."first_name" = 'Maya' AND "member"."last_name" = 'Mclean';	student_club
SELECT COUNT("e"."event_id") FROM "attendance" AS "a" JOIN "member" AS "m" ON "a"."link_to_member" = "m"."member_id" JOIN "event" AS "e" ON "a"."link_to_event" = "e"."event_id" WHERE "m"."first_name" = 'Sacha' AND "m"."last_name" = 'Harrison' AND strftime('%Y', "e"."event_date") = '2019';	student_club
SELECT COUNT(DISTINCT "e"."event_id") AS "meeting_count" FROM "event" AS "e" JOIN "attendance" AS "a" ON "e"."event_id" = "a"."link_to_event" WHERE "e"."type" = 'meeting' GROUP BY "e"."event_id" HAVING COUNT("a"."link_to_member") > 10;	student_club
SELECT "event"."event_name" FROM "event" JOIN "attendance" ON "event"."event_id" = "attendance"."link_to_event" WHERE "event"."type" != 'fundraiser' GROUP BY "event"."event_name" HAVING COUNT("attendance"."link_to_member") > 20	student_club
SELECT COUNT("link_to_member") * 1.0 / COUNT(DISTINCT "link_to_event") AS average_attendance FROM "attendance" JOIN "event" ON "attendance"."link_to_event" = "event"."event_id" WHERE "event"."event_date" LIKE '2020%';	student_club
SELECT "expense_description", MAX("cost") AS "max_cost" FROM "expense"	student_club
SELECT COUNT("member_id") FROM "member" WHERE "link_to_major" = (SELECT "major_id" FROM "major" WHERE "major_name" = 'Environmental Engineering');	student_club
SELECT "member"."first_name", "member"."last_name" FROM "member" JOIN "attendance" ON "member"."link_to_member" = "attendance"."link_to_member" JOIN "event" ON "attendance"."link_to_event" = "event"."link_to_event" WHERE "event"."event_name" = 'Laugh Out Loud';	student_club
SELECT "last_name" FROM "member" WHERE "link_to_major" = (SELECT "major_id" FROM "major" WHERE "major_name" = 'Law and Constitutional Studies');	student_club
SELECT "county" FROM "zip_code" WHERE "zip_code" = (SELECT "zip" FROM "member" WHERE "first_name" = 'Sherri' AND "last_name" = 'Ramsey');	student_club
SELECT "college" FROM "major" WHERE "major_id" = (SELECT "link_to_major" FROM "member" WHERE "first_name" = 'Tyler' AND "last_name" = 'Hewitt')	student_club
SELECT "amount" FROM "income" WHERE "link_to_member" = (SELECT "member_id" FROM "member" WHERE "position" = 'Vice President')	student_club
SELECT SUM("cost") FROM "expense" WHERE "expense_description" = 'food' AND "expense_date" BETWEEN '2023-09-01' AND '2023-09-30';	student_club
SELECT "city", "state" FROM "zip_code" WHERE "zip_code" = (SELECT "zip" FROM "member" WHERE "position" = 'President');	student_club
SELECT "first_name", "last_name" FROM "member" WHERE "zip" IN (SELECT "zip_code" FROM "zip_code" WHERE "state" = 'Illinois')	student_club
SELECT SUM("cost") AS total_spent FROM "expense" WHERE "expense_description" = 'advertisement' AND "expense_date" BETWEEN '2023-09-01' AND '2023-09-30';	student_club
SELECT "department" FROM "major" WHERE "major_id" IN (SELECT "link_to_major" FROM "member" WHERE "first_name" IN ('Pierce', 'Guidi'))	student_club
SELECT SUM("amount") FROM "budget" WHERE "link_to_event" = 'October Speaker'	student_club
SELECT "expense"."approved" FROM "expense" JOIN "budget" ON "expense"."link_to_budget" = "budget"."budget_id" JOIN "event" ON "budget"."link_to_event" = "event"."event_id" WHERE "event"."event_name" = 'October Meeting' AND "event"."event_date" = '2019-10-08';	student_club
SELECT AVG("cost") AS "average_cost" FROM "expense" WHERE "link_to_member" = (SELECT "member_id" FROM "member" WHERE "first_name" = 'Elijah' AND "last_name" = 'Allen') AND date("expense_date") BETWEEN '2023-09-01' AND '2023-10-31';	student_club
SELECT SUM(CASE WHEN date('now', 'start of year', '-4 years') <= "event_date" AND "event_date" < date('now', 'start of year', '-3 years') THEN "amount" ELSE 0 END) AS "total_spent_2019", SUM(CASE WHEN date('now', 'start of year', '-3 years') <= "event_date" AND "event_date" < date('now', 'start of year', '-2 years') THEN "amount" ELSE 0 END) AS "total_spent_2020" FROM budget JOIN event ON "link_to_event" = "event_id" WHERE "event_date" BETWEEN '2019-01-01' AND '2020-12-31';	student_club
SELECT "location" FROM "event" WHERE "event_name" = 'Spring Budget Review'	student_club
SELECT "cost" FROM "expense" WHERE "expense_description" = 'Posters' AND "expense_date" = '2019/9/4'	student_club
SELECT "remaining" FROM "budget" WHERE "category" = 'Food' ORDER BY "amount" DESC LIMIT 1	student_club
SELECT "notes" FROM "event" WHERE "event_date" = '2019/9/14' AND "event_name" = 'fundraising';	student_club
SELECT COUNT("major_id") FROM "major" WHERE "college" = 'College of Humanities and Social Sciences';	student_club
SELECT "phone" FROM "member" WHERE "first_name" = 'Carlo' AND "last_name" = 'Jacobs'	student_club
SELECT "county" FROM "zip_code" WHERE "zip_code" = (SELECT "zip" FROM "member" WHERE "first_name" = 'Adela' AND "last_name" = 'O''Gallagher');	student_club
SELECT COUNT(*) FROM "budget" WHERE "link_to_event" = (SELECT "link_to_event" FROM "event" WHERE "event_name" = 'November Meeting') AND "spent" > "amount";	student_club
SELECT SUM("amount") FROM "budget" WHERE "link_to_event" = 'September Speaker';	student_club
SELECT "event"."status" FROM "event" JOIN "expense" ON "event"."event_id" = "expense"."link_to_budget" WHERE "expense"."expense_description" = 'Post Cards, Posters' AND "expense"."expense_date" = '2019/8/20';	student_club
SELECT "major"."major_name" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "member"."first_name" = 'Brent' AND "member"."last_name" = 'Thomason';	student_club
SELECT COUNT("member"."member_id") AS "medium_tshirt_count" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "major"."major_name" = 'Business' AND "member"."t_shirt_size" = 'M';	student_club
SELECT "zip_code"."type" FROM "member" JOIN "zip_code" ON "member"."zip" = "zip_code"."zip_code" WHERE "member"."first_name" = 'Christof' AND "member"."last_name" = 'Nielson';	student_club
SELECT "major"."major_name" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "member"."position" = 'Vice President'	student_club
SELECT "zip_code"."state" FROM "member" JOIN "zip_code" ON "member"."zip" = "zip_code"."zip_code" WHERE "member"."first_name" = 'Sacha' AND "member"."last_name" = 'Harrison'	student_club
SELECT "department" FROM "member" WHERE "position" = 'President'	student_club
SELECT "expense_date" FROM "expense" WHERE "link_to_member" = (SELECT "member_id" FROM "member" WHERE "first_name" = 'Connor' AND "last_name" = 'Hilton')	student_club
SELECT "first_name", "last_name" FROM "member" WHERE "member_id" = (SELECT "link_to_member" FROM "expense" ORDER BY "expense_date" ASC LIMIT 1)	student_club
SELECT COUNT(*) FROM "budget" WHERE "category" = 'Advertisement' AND "link_to_event" = (SELECT "link_to_event" FROM "event" WHERE "event_name" = 'Yearly Kickoff') AND "amount" > (SELECT "amount" FROM "budget" WHERE "category" = 'Advertisement' AND "link_to_event" = (SELECT "link_to_event" FROM "event" WHERE "event_name" = 'October Meeting'));	student_club
SELECT (SUM("amount") * 100.0 / (SELECT SUM("amount") FROM "budget" WHERE "link_to_event" = 'November Speaker')) AS "percentage" FROM "budget" WHERE "category" = 'Parking' AND "link_to_event" = 'November Speaker';	student_club
SELECT SUM("cost") FROM "expense" WHERE "expense_description" LIKE '%pizza%'	student_club
SELECT COUNT(DISTINCT "city") FROM "zip_code" WHERE "county" = 'Orange' AND "state" = 'Virginia';	student_club
SELECT "department" FROM "major" WHERE "college" = 'College of Humanities and Social Sciences'	student_club
SELECT "zip" FROM "member" WHERE "first_name" = 'Amy' AND "last_name" = 'Firth'	student_club
SELECT "expense_id", "expense_description", "expense_date", "cost" FROM "expense" WHERE "link_to_budget" = (SELECT "link_to_event" FROM "budget" ORDER BY "remaining" ASC LIMIT 1)	student_club
SELECT "member"."first_name", "member"."last_name" FROM "member" JOIN "attendance" ON "member"."link_to_member" = "attendance"."link_to_member" JOIN "event" ON "attendance"."link_to_event" = "event"."link_to_event" WHERE "event"."event_name" = 'October Meeting';	student_club
SELECT "college", COUNT("member_id") AS "member_count" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" GROUP BY "college" ORDER BY "member_count" DESC LIMIT 1;	student_club
SELECT "major"."major_name" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "member"."phone" = '809-555-3360';	student_club
SELECT "event"."event_name", MAX("budget"."amount") AS "highest_budget" FROM "budget" JOIN "event" ON "budget"."link_to_event" = "event"."event_id" GROUP BY "event"."event_name" ORDER BY "highest_budget" DESC LIMIT 1	student_club
SELECT "expense_id", "expense_description", "expense_date", "cost" FROM "expense" WHERE "link_to_member" IN (SELECT "link_to_member" FROM "member" WHERE "position" = 'vice president')	student_club
SELECT COUNT(DISTINCT "link_to_member") FROM "attendance" JOIN "event" ON "attendance"."link_to_event" = "event"."event_id" WHERE "event"."event_name" = 'Women's Soccer';	student_club
SELECT "date_received" FROM "income" WHERE "link_to_member" = (SELECT "member_id" FROM "member" WHERE "first_name" = 'Casey' AND "last_name" = 'Mason')	student_club
SELECT COUNT(DISTINCT "zip") FROM "member" JOIN "zip_code" ON "member"."zip" = "zip_code"."zip_code" WHERE "zip_code"."state" = 'Maryland';	student_club
SELECT COUNT("link_to_event") FROM "attendance" WHERE "link_to_member" IN (SELECT "link_to_member" FROM "member" WHERE "phone" = '954-555-6240');	student_club
SELECT "first_name", "last_name", "email" FROM "member" WHERE "link_to_major" IN (SELECT "major_id" FROM "major" WHERE "department" = 'School of Applied Sciences, Technology and Education')	student_club
SELECT "event"."event_name", "budget"."spent" / "budget"."amount" AS "spend_to_budget_ratio" FROM "event" JOIN "budget" ON "event"."event_id" = "budget"."link_to_event" WHERE "event"."status" = 'closed' ORDER BY "spend_to_budget_ratio" DESC LIMIT 1;	student_club
SELECT COUNT("member_id") FROM "member" WHERE "position" = 'president';	student_club
SELECT MAX("spent") FROM "budget"	student_club
SELECT COUNT("event_id") FROM "event" WHERE "type" = 'meeting' AND "event_date" BETWEEN '2020-01-01' AND '2020-12-31';	student_club
SELECT SUM("cost") FROM "expense" WHERE "expense_description" LIKE '%food%'	student_club
SELECT "first_name", "last_name" FROM "member" WHERE "member_id" IN (SELECT "link_to_member" FROM "attendance" GROUP BY "link_to_member" HAVING COUNT("link_to_event") > 7)	student_club
SELECT "member"."first_name", "member"."last_name" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" JOIN "attendance" ON "member"."member_id" = "attendance"."link_to_member" JOIN "event" ON "attendance"."link_to_event" = "event"."event_id" WHERE "major"."major_name" = 'Interior Design' AND "event"."event_name" = 'Community Theater';	student_club
SELECT "first_name", "last_name" FROM "member" WHERE "zip" IN (SELECT "zip_code" FROM "zip_code" WHERE "city" = 'Georgetown' AND "state" = 'South Carolina')	student_club
SELECT COUNT("income_id") FROM "income" WHERE "link_to_member" = (SELECT "member_id" FROM "member" WHERE "first_name" = 'Grant' AND "last_name" = 'Gilmour');	student_club
SELECT "link_to_member" FROM "income" WHERE "amount" > 40	student_club
SELECT SUM("cost") FROM "expense" WHERE "link_to_budget" IN (SELECT "link_to_event" FROM "event" WHERE "event_name" = 'Yearly Kickoff')	student_club
SELECT "first_name", "last_name" FROM "member" WHERE "member_id" IN (SELECT "link_to_member" FROM "budget" WHERE "category" = 'Yearly Kickoff');	student_club
SELECT "first_name", "last_name", "source" FROM "member" JOIN "income" ON "member"."member_id" = "income"."link_to_member" ORDER BY "amount" DESC LIMIT 1;	student_club
SELECT "event"."event_name" FROM "event" JOIN "budget" ON "event"."event_id" = "budget"."link_to_event" ORDER BY "budget"."spent" ASC LIMIT 1	student_club
SELECT (SUM("cost") / (SELECT SUM("cost") FROM "expense" JOIN "event" ON "expense"."link_to_event" = "event"."event_id")) * 100 AS "percentage" FROM "expense" WHERE "link_to_event" IN (SELECT "event_id" FROM "event" WHERE "event_name" = 'Yearly Kickoff');	student_club
SELECT (SELECT COUNT(*) FROM member WHERE "link_to_major" IN (SELECT "major_id" FROM major WHERE "major_name" = 'Finance')) AS finance_count, (SELECT COUNT(*) FROM member WHERE "link_to_major" IN (SELECT "major_id" FROM major WHERE "major_name" = 'Physics')) AS physics_count;	student_club
SELECT "source", SUM("amount") AS total_amount FROM "income" WHERE date("date_received") >= '2019-09-01' AND date("date_received") < '2019-10-01' GROUP BY "source" ORDER BY total_amount DESC LIMIT 1	student_club
SELECT "first_name", "last_name", "email" FROM "member" WHERE "position" = 'Secretary'	student_club
SELECT COUNT("member_id") FROM "member" WHERE "link_to_major" = (SELECT "major_id" FROM "major" WHERE "major_name" = 'Physics Teaching');	student_club
SELECT COUNT(DISTINCT "link_to_member") FROM "attendance" JOIN "event" ON "attendance"."link_to_event" = "event"."event_id" WHERE "event"."event_name" = 'Community Theater' AND strftime('%Y', "event"."event_date") = '2019';	student_club
SELECT COUNT("attendance"."link_to_event") AS "event_count", "major"."major_name" FROM "attendance" JOIN "member" ON "attendance"."link_to_member" = "member"."member_id" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "member"."first_name" = 'Luisa' AND "member"."last_name" = 'Guidi';	student_club
SELECT AVG("cost") AS "average_spent" FROM "expense" WHERE "expense_description" = 'food'	student_club
SELECT "event"."event_name" FROM "event" JOIN "budget" ON "event"."event_id" = "budget"."link_to_event" WHERE "budget"."category" = 'advertisement' ORDER BY "budget"."spent" DESC LIMIT 1	student_club
SELECT "attendance"."link_to_event" FROM "attendance" JOIN "member" ON "attendance"."link_to_member" = "member"."member_id" JOIN "event" ON "attendance"."link_to_event" = "event"."event_id" WHERE "member"."first_name" = 'Maya' AND "member"."last_name" = 'Mclean' AND "event"."event_name" = 'Women''s Soccer';	student_club
SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM "event" WHERE date("event_date") BETWEEN '2019-01-01' AND '2019-12-31') AS "percentage_share" FROM "event" WHERE "type" = 'Community Service' AND date("event_date") BETWEEN '2019-01-01' AND '2019-12-31';	student_club
SELECT "cost" FROM "expense" WHERE "expense_description" = 'posters' AND "link_to_budget" IN (SELECT "link_to_event" FROM "event" WHERE "event_name" = 'September Speaker');	student_club
SELECT "t_shirt_size", COUNT("t_shirt_size") AS "size_count" FROM "member" GROUP BY "t_shirt_size" ORDER BY "size_count" DESC LIMIT 1	student_club
SELECT "event"."event_name" FROM "event" JOIN "budget" ON "event"."event_id" = "budget"."link_to_event" WHERE "budget"."event_status" = 'closed' ORDER BY ("budget"."amount" - "budget"."spent") ASC LIMIT 1	student_club
SELECT "expense_description", SUM("cost") AS total_value FROM "expense" WHERE "link_to_budget" IN (SELECT "link_to_event" FROM "budget" WHERE "category" = 'October Meeting' AND "event_status" = 'approved') GROUP BY "expense_description"	student_club
SELECT "category", "amount" FROM budget WHERE "link_to_event" = (SELECT "event_id" FROM event WHERE "event_name" = 'April Speaker') ORDER BY "amount" ASC	student_club
SELECT "budget_id", "amount" FROM budget WHERE "category" = 'Food' ORDER BY "amount" DESC LIMIT 1	student_club
SELECT "budget_id", "amount" FROM budget WHERE "category" = 'Advertising' ORDER BY "amount" DESC LIMIT 3	student_club
SELECT SUM("cost") FROM "expense" WHERE "expense_description" = 'Parking'	student_club
SELECT SUM("cost") AS total_expense FROM "expense" WHERE "expense_date" = '2019-08-20'	student_club
SELECT "first_name", "last_name", SUM("cost") AS "total_cost" FROM "member" JOIN "expense" ON "member"."member_id" = "expense"."link_to_member" WHERE "member"."member_id" = 'rec4BLdZHS2Blfp4v' GROUP BY "first_name", "last_name";	student_club
SELECT "expense_description" FROM "expense" WHERE "link_to_member" = (SELECT "member_id" FROM "member" WHERE "first_name" = 'Sacha' AND "last_name" = 'Harrison')	student_club
SELECT "expense_description" FROM "expense" WHERE "link_to_member" IN (SELECT "link_to_member" FROM "member" WHERE "t_shirt_size" = 'X-Large')	student_club
SELECT "zip" FROM "member" WHERE "member_id" IN (SELECT "link_to_member" FROM "expense" WHERE "cost" < 50);	student_club
SELECT "major"."major_name" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "member"."first_name" = 'Phillip' AND "member"."last_name" = 'Cullen';	student_club
SELECT "position" FROM "member" WHERE "link_to_major" IN (SELECT "major_id" FROM "major" WHERE "major_name" = 'Business')	student_club
SELECT COUNT("member_id") FROM "member" WHERE "link_to_major" IN (SELECT "major_id" FROM "major" WHERE "major_name" = 'Business') AND "t_shirt_size" = 'Medium';	student_club
SELECT DISTINCT "event"."type" FROM "event" JOIN "budget" ON "event"."link_to_event" = "budget"."link_to_event" WHERE "budget"."remaining" > 30;	student_club
SELECT "type" FROM "event" WHERE "location" = 'MU 215'	student_club
SELECT "type" FROM "event" WHERE "event_date" = '2020-03-24T12:00:00'	student_club
SELECT "major"."major_name" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "member"."position" = 'Vice President';	student_club
SELECT (COUNT(CASE WHEN "link_to_major" IN (SELECT "major_id" FROM "major" WHERE "major_name" = 'Business') THEN 1 END) * 100.0 / COUNT(*)) AS "percentage_business_members" FROM "member";	student_club
SELECT "type" FROM "event" WHERE "location" = 'MU 215'	student_club
SELECT COUNT("income_id") FROM "income" WHERE "amount" = 50	student_club
SELECT COUNT(*) FROM "member" WHERE "t_shirt_size" = 'XL'	student_club
SELECT COUNT("major_id") FROM "major" WHERE "department" = 'School of Applied Sciences, Technology and Education' AND "college" = 'College of Agriculture and Applied Sciences';	student_club
SELECT "last_name", "department", "college" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "major"."major_name" = 'Environmental Engineering'	student_club
SELECT "category" FROM "budget" b JOIN "event" e ON b."link_to_event" = e."event_id" WHERE e."location" = 'MU 215' AND e."type" = 'guest speaker' AND b."spent" = 0	student_club
SELECT "city", "state" FROM "zip_code" JOIN "member" ON "member"."zip" = "zip_code"."zip_code" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "major"."department" = 'Electrical and Computer Engineering';	student_club
SELECT "event"."event_name" FROM "event" JOIN "attendance" ON "event"."event_id" = "attendance"."link_to_event" JOIN "member" ON "attendance"."link_to_member" = "member"."member_id" WHERE "member"."position" = 'vice president' AND "event"."location" = '900 E. Washington St.'	student_club
SELECT "last_name", "position" FROM "member" WHERE "member_id" IN (SELECT "link_to_member" FROM "expense" WHERE "expense_description" = 'pizza' AND "expense_date" = '2019-09-10')	student_club
SELECT "member"."last_name" FROM "member" JOIN "attendance" ON "member"."link_to_member" = "attendance"."link_to_member" JOIN "event" ON "attendance"."link_to_event" = "event"."link_to_event" WHERE "event"."event_name" = 'women\'s soccer';	student_club
SELECT (SUM("amount") * 100.0 / 50) AS "percentage" FROM "income" WHERE "link_to_member" IN (SELECT "member_id" FROM "member" WHERE "t_shirt_size" = 'medium');	student_club
SELECT DISTINCT "county" FROM "zip_code" WHERE "type" = 'Post Office Box'	student_club
SELECT "zip_code" FROM "zip_code" WHERE "county" = 'San Juan Municipio' AND "state" = 'Puerto Rico' AND "type" = 'PO Box'	student_club
SELECT "event_name" FROM "event" WHERE "type" = 'game' AND "status" = 'closed' AND "event_date" BETWEEN '2019-03-15' AND '2020-03-20'	student_club
SELECT DISTINCT "attendance"."link_to_event" FROM "attendance" JOIN "income" ON "attendance"."link_to_member" = "income"."link_to_member" WHERE "income"."amount" > 50	student_club
SELECT "m"."first_name", "m"."last_name", "a"."link_to_event" FROM "member" AS "m" JOIN "attendance" AS "a" ON "m"."member_id" = "a"."link_to_member" JOIN "event" AS "e" ON "a"."link_to_event" = "e"."event_id" WHERE "e"."event_date" BETWEEN '2019-01-10' AND '2019-11-19' AND "e"."status" = 'approved';	student_club
SELECT "major"."college" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "member"."first_name" = 'Katy' AND "member"."link_to_major" = 'rec1N0upiVLy5esTO';	student_club
SELECT "member"."phone" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "major"."major_name" = 'business' AND "major"."college" = 'College of Agriculture and Applied Sciences';	student_club
SELECT "email" FROM "member" INNER JOIN "income" ON "member"."member_id" = "income"."link_to_member" WHERE "income"."amount" > 20 AND "income"."date_received" BETWEEN '2019-09-10' AND '2019-11-19';	student_club
SELECT COUNT("member_id") FROM "member" WHERE "link_to_major" IN (SELECT "major_id" FROM "major" WHERE "major_name" = 'education' AND "college" = 'College of Education & Human Services');	student_club
SELECT (SUM(CASE WHEN "event_status" = 'over budget' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS "percentage_over_budget" FROM "budget"	student_club
SELECT "event_id", "location", "status" FROM "event" WHERE "event_date" BETWEEN '2019-11-01' AND '2020-03-31'	student_club
SELECT "expense_description", AVG("cost") AS "average_cost" FROM "expense" GROUP BY "expense_description" HAVING AVG("cost") > 50	student_club
SELECT "first_name", "last_name" FROM "member" WHERE "t_shirt_size" = 'extra large'	student_club
SELECT (SUM(CASE WHEN "type" = 'PO Box' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS "percentage_of_po_boxes" FROM "zip_code"	student_club
SELECT "event"."event_name", "event"."location" FROM "event" JOIN "budget" ON "event"."event_id" = "budget"."link_to_event" WHERE "budget"."spent" < "budget"."amount";	student_club
SELECT "event"."event_name", "event"."event_date" FROM "event" JOIN "expense" ON "event"."event_id" = "expense"."link_to_budget" WHERE "expense"."expense_description" = 'pizza' AND "expense"."cost" > 50 AND "expense"."cost" < 100;	student_club
SELECT "first_name", "last_name", "link_to_major" FROM "member" JOIN "expense" ON "member"."member_id" = "expense"."link_to_member" WHERE "expense"."cost" > 100;	student_club
SELECT "zip_code"."city", "zip_code"."county" FROM "event" JOIN "income" ON "event"."event_id" = "income"."link_to_event" JOIN "zip_code" ON "event"."location" = "zip_code"."zip_code" GROUP BY "event"."event_id" HAVING COUNT("income"."income_id") > 40;	student_club
SELECT "link_to_member", SUM("cost") AS total_cost FROM "expense" WHERE "link_to_member" IN (SELECT "link_to_member" FROM "expense" GROUP BY "link_to_member" HAVING COUNT(DISTINCT "link_to_budget") > 1) GROUP BY "link_to_member" ORDER BY total_cost DESC LIMIT 1;	student_club
SELECT AVG("amount") FROM "income" WHERE "link_to_member" IN (SELECT "member_id" FROM "member" WHERE "position" != 'member')	student_club
SELECT "event"."event_name" FROM "event" JOIN "expense" ON "event"."event_id" = "expense"."link_to_event" GROUP BY "event"."event_id" HAVING AVG("expense"."cost") < (SELECT AVG("cost") FROM "expense");	student_club
SELECT SUM("cost") * 100.0 / (SELECT SUM("amount") FROM "budget" WHERE "event_status" = 'meeting') AS "percentage_cost" FROM "expense" WHERE "link_to_budget" IN (SELECT "link_to_event" FROM "event" WHERE "type" = 'meeting');	student_club
SELECT "budget"."category", "budget"."amount" FROM "budget" WHERE "budget"."category" IN ('water', 'chips', 'cookies') ORDER BY "budget"."amount" DESC LIMIT 1	student_club
SELECT "m"."first_name", "m"."last_name", SUM("e"."cost") AS "total_spent" FROM "member" AS "m" JOIN "expense" AS "e" ON "m"."link_to_member" = "e"."link_to_member" GROUP BY "m"."member_id" ORDER BY "total_spent" DESC LIMIT 5;	student_club
SELECT "first_name", "last_name", "phone" FROM "member" WHERE "member_id" IN (SELECT "link_to_member" FROM "expense" WHERE "cost" > (SELECT AVG("cost") FROM "expense"));	student_club
SELECT (SELECT COUNT(*) FROM member JOIN zip_code ON member.zip = zip_code.zip_code WHERE zip_code.state = 'New Jersey') AS nj_count, (SELECT COUNT(*) FROM member JOIN zip_code ON member.zip = zip_code.zip_code WHERE zip_code.state = 'Vermont') AS vt_count;	student_club
SELECT "major"."major_name", "major"."department" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "member"."first_name" = 'Garrett' AND "member"."last_name" = 'Gerke';	student_club
SELECT "first_name", "last_name", "cost" FROM "member" JOIN "expense" ON "member"."member_id" = "expense"."link_to_member" WHERE "expense"."expense_description" IN ('water', 'veggie tray', 'supplies');	student_club
SELECT "last_name", "phone" FROM "member" WHERE "link_to_major" IN (SELECT "major_id" FROM "major" WHERE "major_name" = 'Elementary Education');	student_club
SELECT "b"."category", "b"."amount" FROM "budget" AS "b" JOIN "event" AS "e" ON "b"."link_to_event" = "e"."event_id" WHERE "e"."event_name" = 'January Speaker'	student_club
SELECT "event"."event_name" FROM "event" JOIN "budget" ON "event"."event_id" = "budget"."link_to_event" WHERE "budget"."category" = 'food';	student_club
SELECT "first_name", "last_name", "amount" FROM "member" JOIN "income" ON "member"."member_id" = "income"."link_to_member" WHERE "date_received" = '2019-09-09';	student_club
SELECT "category" FROM "budget" WHERE "link_to_event" IN (SELECT "link_to_event" FROM "expense" WHERE "expense_description" = 'Posters')	student_club
SELECT "first_name", "last_name", "college" FROM "member" JOIN "major" ON "member"."link_to_major" = "major"."major_id" WHERE "position" = 'Secretary';	student_club
SELECT "event"."event_name", SUM("expense"."cost") AS "total_spent" FROM "expense" JOIN "budget" ON "expense"."link_to_budget" = "budget"."budget_id" JOIN "event" ON "budget"."link_to_event" = "event"."event_id" WHERE "expense"."expense_description" = 'speaker gifts' GROUP BY "event"."event_name";	student_club
SELECT "zip" FROM "member" WHERE "first_name" = 'Garrett' AND "last_name" = 'Gerke'	student_club
SELECT "first_name", "last_name", "position" FROM "member" WHERE "zip" = 28092	student_club
SELECT COUNT("GasStationID") FROM "gasstations" WHERE "Country" = 'CZE' AND "Segment" = 'Premium';	debit_card_specializing
SELECT SUM(CASE WHEN "Currency" = 'EUR' THEN 1 ELSE 0 END) AS "EUR_Customers", SUM(CASE WHEN "Currency" = 'CZK' THEN 1 ELSE 0 END) AS "CZK_Customers" FROM "customers";	debit_card_specializing
SELECT "CustomerID", SUM("Consumption") AS "TotalConsumption" FROM "yearmonth" WHERE "Date" LIKE '2012%' GROUP BY "CustomerID" ORDER BY "TotalConsumption" ASC LIMIT 1	debit_card_specializing
SELECT AVG("Consumption") FROM "yearmonth" WHERE "CustomerID" IN (SELECT "CustomerID" FROM "customers" WHERE "Segment" = 'SME') AND "Date" LIKE '2013-%';	debit_card_specializing
SELECT "customers"."CustomerID", SUM("yearmonth"."Consumption") AS "TotalConsumption" FROM "customers" JOIN "yearmonth" ON "customers"."CustomerID" = "yearmonth"."CustomerID" WHERE "customers"."Currency" = 'CZK' AND "yearmonth"."Date" LIKE '2011%' GROUP BY "customers"."CustomerID" ORDER BY "TotalConsumption" DESC LIMIT 1;	debit_card_specializing
SELECT COUNT(DISTINCT "CustomerID") FROM "yearmonth" WHERE "Date" LIKE '2012%' AND "Consumption" < 30000 AND "CustomerID" IN (SELECT "CustomerID" FROM "customers" WHERE "Segment" = 'KAM');	debit_card_specializing
SELECT SUM(CASE WHEN c."Currency" = 'CZK' THEN ym."Consumption" ELSE 0 END) AS "CZK_Consumption", SUM(CASE WHEN c."Currency" = 'EUR' THEN ym."Consumption" ELSE 0 END) AS "EUR_Consumption" FROM "customers" c JOIN "yearmonth" ym ON c."CustomerID" = ym."CustomerID" WHERE strftime('%Y', ym."Date") = '2012';	debit_card_specializing
SELECT strftime('%Y', "Date") AS "Year", SUM("Amount") AS "TotalAmount" FROM "transactions_1k" t JOIN "customers" c ON t."CustomerID" = c."CustomerID" WHERE c."Currency" = 'EUR' GROUP BY "Year" ORDER BY "TotalAmount" DESC LIMIT 1;	debit_card_specializing
SELECT "customers"."Segment", SUM("yearmonth"."Consumption") AS total_consumption FROM "yearmonth" JOIN "customers" ON "yearmonth"."CustomerID" = "customers"."CustomerID" GROUP BY "customers"."Segment" ORDER BY total_consumption ASC LIMIT 1;	debit_card_specializing
SELECT strftime('%Y', "yearmonth"."Date") AS "Year", SUM("yearmonth"."Consumption") AS "TotalConsumption" FROM "yearmonth" JOIN "customers" ON "yearmonth"."CustomerID" = "customers"."CustomerID" WHERE "customers"."Currency" = 'CZK' GROUP BY "Year" ORDER BY "TotalConsumption" DESC LIMIT 1;	debit_card_specializing
SELECT "Date", SUM("Consumption") AS "TotalConsumption" FROM "yearmonth" JOIN "customers" ON "yearmonth"."CustomerID" = "customers"."CustomerID" WHERE "customers"."Segment" = 'SME' AND "yearmonth"."Date" LIKE '2013-%' GROUP BY "Date" ORDER BY "TotalConsumption" DESC LIMIT 1;	debit_card_specializing
SELECT "Segment", AVG("Consumption") AS "AverageConsumption" FROM yearmonth WHERE "Date" LIKE '2013%' AND "CustomerID" IN (SELECT "CustomerID" FROM customers WHERE "Currency" = 'CZK' ORDER BY "CustomerID" LIMIT 1) GROUP BY "Segment";	debit_card_specializing
SELECT "Segment", SUM(CASE WHEN "Date" BETWEEN '2012-01-01' AND '2012-12-31' THEN "Consumption" ELSE 0 END) AS "Consumption_2012", SUM(CASE WHEN "Date" BETWEEN '2013-01-01' AND '2013-12-31' THEN "Consumption" ELSE 0 END) AS "Consumption_2013", (SUM(CASE WHEN "Date" BETWEEN '2013-01-01' AND '2013-12-31' THEN "Consumption" ELSE 0 END) - SUM(CASE WHEN "Date" BETWEEN '2012-01-01' AND '2012-12-31' THEN "Consumption" ELSE 0 END)) * 100.0 / NULLIF(SUM(CASE WHEN "Date" BETWEEN '2012-01-01' AND '2012-12-31' THEN "Consumption" ELSE 0 END), 0) AS "Percentage_Increase" FROM "yearmonth" WHERE "CustomerID" IN (SELECT "CustomerID" FROM "customers" WHERE "Currency" = 'EUR') GROUP BY "Segment";	debit_card_specializing
SELECT SUM("Consumption") AS "TotalConsumption" FROM "yearmonth" WHERE "CustomerID" = 6 AND "Date" BETWEEN '2013-08-01' AND '2013-11-30';	debit_card_specializing
SELECT (SELECT COUNT(*) FROM "gasstations" WHERE "Country" = 'Czech Republic' AND "Segment" = 'discount') - (SELECT COUNT(*) FROM "gasstations" WHERE "Country" = 'Slovakia' AND "Segment" = 'discount') AS "Difference";	debit_card_specializing
SELECT "y1"."Consumption" - "y2"."Consumption" AS "Difference" FROM "yearmonth" AS "y1" JOIN "yearmonth" AS "y2" ON "y1"."Date" = "y2"."Date" WHERE "y1"."CustomerID" = 7 AND "y2"."CustomerID" = 5 AND "y1"."Date" LIKE '2013-04%';	debit_card_specializing
SELECT SUM(CASE WHEN "Currency" = 'CZK' THEN 1 ELSE 0 END) AS "CZK_Count", SUM(CASE WHEN "Currency" = 'EUR' THEN 1 ELSE 0 END) AS "EUR_Count" FROM "customers";	debit_card_specializing
SELECT "customers"."CustomerID" FROM "customers" JOIN "yearmonth" ON "customers"."CustomerID" = "yearmonth"."CustomerID" WHERE "customers"."Segment" = 'LAM' AND "customers"."Currency" = 'Euro' AND "yearmonth"."Date" LIKE '2013-10%' ORDER BY "yearmonth"."Consumption" DESC LIMIT 1;	debit_card_specializing
SELECT "customers"."CustomerID", SUM("yearmonth"."Consumption") AS "TotalConsumption" FROM "customers" JOIN "yearmonth" ON "customers"."CustomerID" = "yearmonth"."CustomerID" WHERE "customers"."Segment" = 'KAM' GROUP BY "customers"."CustomerID" ORDER BY "TotalConsumption" DESC LIMIT 1;	debit_card_specializing
SELECT SUM("Consumption") AS "TotalConsumption" FROM "yearmonth" JOIN "customers" ON "yearmonth"."CustomerID" = "customers"."CustomerID" WHERE "customers"."Segment" = 'KAM' AND "yearmonth"."Date" LIKE '2013-05%';	debit_card_specializing
SELECT COUNT(DISTINCT "CustomerID") * 100.0 / (SELECT COUNT(DISTINCT "CustomerID") FROM "customers" WHERE "Segment" = 'LAM') AS "Percentage" FROM "yearmonth" WHERE "Consumption" > 46.73 AND "CustomerID" IN (SELECT "CustomerID" FROM "customers" WHERE "Segment" = 'LAM');	debit_card_specializing
SELECT "Country", COUNT("GasStationID") AS "TotalValueForMoney" FROM "gasstations" WHERE "Segment" = 'value for money' GROUP BY "Country"	debit_card_specializing
SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM "customers" WHERE "Segment" = 'KAM')) AS "Percentage" FROM "customers" WHERE "Segment" = 'KAM' AND "Currency" = 'EUR';	debit_card_specializing
SELECT COUNT(DISTINCT "CustomerID") * 100.0 / (SELECT COUNT(DISTINCT "CustomerID") FROM "yearmonth" WHERE "Date" LIKE '2012-02%') AS "Percentage" FROM "yearmonth" WHERE "Date" LIKE '2012-02%' AND "Consumption" > 528.3;	debit_card_specializing
SELECT (COUNT(CASE WHEN "Segment" = 'premium' THEN 1 END) * 100.0 / COUNT(*)) AS "Percentage" FROM "gasstations" WHERE "Country" = 'Slovakia';	debit_card_specializing
SELECT "CustomerID", SUM("Consumption") AS "TotalConsumption" FROM "yearmonth" WHERE "Date" LIKE '2013-09%' GROUP BY "CustomerID" ORDER BY "TotalConsumption" DESC LIMIT 1;	debit_card_specializing
SELECT "Segment", SUM("Consumption") AS "TotalConsumption" FROM "yearmonth" JOIN "customers" ON "yearmonth"."CustomerID" = "customers"."CustomerID" WHERE "Date" LIKE '2013-09%' GROUP BY "Segment" ORDER BY "TotalConsumption" ASC LIMIT 1;	debit_card_specializing
SELECT "customers"."CustomerID", SUM("yearmonth"."Consumption") AS "TotalConsumption" FROM "yearmonth" JOIN "customers" ON "yearmonth"."CustomerID" = "customers"."CustomerID" WHERE "yearmonth"."Date" LIKE '2012-06%' AND "customers"."Segment" = 'SME' GROUP BY "customers"."CustomerID" ORDER BY "TotalConsumption" ASC LIMIT 1;	debit_card_specializing
SELECT MAX("Consumption") FROM "yearmonth" WHERE "Date" LIKE '2012-%'	debit_card_specializing
SELECT MAX("Consumption") FROM "yearmonth" WHERE "CustomerID" IN (SELECT "CustomerID" FROM "customers" WHERE "Currency" = 'euro')	debit_card_specializing
SELECT "products"."Description" FROM "transactions_1k" JOIN "products" ON "transactions_1k"."ProductID" = "products"."ProductID" WHERE strftime('%Y-%m', "transactions_1k"."Date") = '2013-09';	debit_card_specializing
SELECT DISTINCT "gasstations"."Country" FROM "transactions_1k" JOIN "gasstations" ON "transactions_1k"."GasStationID" = "gasstations"."GasStationID" WHERE strftime('%Y-%m', "transactions_1k"."Date") = '2013-06';	debit_card_specializing
SELECT DISTINCT g."ChainID" FROM "transactions_1k" t JOIN "customers" c ON t."CustomerID" = c."CustomerID" JOIN "gasstations" g ON t."GasStationID" = g."GasStationID" WHERE c."Currency" = 'euro';	debit_card_specializing
SELECT "products"."Description" FROM "transactions_1k" JOIN "customers" ON "transactions_1k"."CustomerID" = "customers"."CustomerID" JOIN "products" ON "transactions_1k"."ProductID" = "products"."ProductID" WHERE "customers"."Currency" = 'euro';	debit_card_specializing
SELECT AVG("Price") FROM "transactions_1k" WHERE "Date" BETWEEN '2012-01-01' AND '2012-01-31'	debit_card_specializing
SELECT COUNT(DISTINCT "customers"."CustomerID") FROM "customers" JOIN "yearmonth" ON "customers"."CustomerID" = "yearmonth"."CustomerID" WHERE "customers"."Currency" = 'euro' AND "yearmonth"."Consumption" > 1000;	debit_card_specializing
SELECT "products"."Description" FROM "transactions_1k" JOIN "gasstations" ON "transactions_1k"."GasStationID" = "gasstations"."GasStationID" JOIN "products" ON "transactions_1k"."ProductID" = "products"."ProductID" WHERE "gasstations"."Country" = 'Czech Republic';	debit_card_specializing
SELECT DISTINCT "Time" FROM "transactions_1k" JOIN "gasstations" ON "transactions_1k"."GasStationID" = "gasstations"."GasStationID" WHERE "gasstations"."ChainID" = 11;	debit_card_specializing
SELECT COUNT("TransactionID") FROM "transactions_1k" t JOIN "gasstations" g ON t."GasStationID" = g."GasStationID" WHERE g."Country" = 'Czech Republic' AND t."Price" > 1000;	debit_card_specializing
SELECT COUNT("TransactionID") FROM "transactions_1k" t JOIN "gasstations" g ON t."GasStationID" = g."GasStationID" WHERE g."Country" = 'Czech Republic' AND t."Date" > '2012-01-01'	debit_card_specializing
SELECT AVG("Price") AS "AveragePrice" FROM "transactions_1k" JOIN "gasstations" ON "transactions_1k"."GasStationID" = "gasstations"."GasStationID" WHERE "gasstations"."Country" = 'Czech Republic';	debit_card_specializing
SELECT AVG("Price") AS "AveragePrice" FROM "transactions_1k" WHERE "CustomerID" IN (SELECT "CustomerID" FROM "customers" WHERE "Currency" = 'euro');	debit_card_specializing
SELECT "CustomerID", SUM("Price") AS "TotalPaid" FROM "transactions_1k" WHERE "Date" = '2012-08-25' GROUP BY "CustomerID" ORDER BY "TotalPaid" DESC LIMIT 1	debit_card_specializing
SELECT "Country" FROM "gasstations" g JOIN "transactions_1k" t ON g."GasStationID" = t."GasStationID" WHERE t."Date" = '2012-08-25' ORDER BY t."TransactionID" LIMIT 1;	debit_card_specializing
SELECT "Currency" FROM "customers" JOIN "transactions_1k" ON "customers"."CustomerID" = "transactions_1k"."CustomerID" WHERE "transactions_1k"."Date" = '2012-08-24' AND "transactions_1k"."Time" = '16:25:00';	debit_card_specializing
SELECT "Segment" FROM "customers" WHERE "CustomerID" IN (SELECT "CustomerID" FROM "transactions_1k" WHERE "Date" = '2012-08-23' AND "Time" = '21:20:00')	debit_card_specializing
SELECT COUNT("TransactionID") FROM "transactions_1k" INNER JOIN "customers" ON "transactions_1k"."CustomerID" = "customers"."CustomerID" WHERE "customers"."Currency" = 'CZK' AND "transactions_1k"."Date" = '2012-08-26' AND "transactions_1k"."Time" < '12:00:00';	debit_card_specializing
SELECT "Segment" FROM "customers" WHERE "CustomerID" = (SELECT MIN("CustomerID") FROM "customers")	debit_card_specializing
SELECT "Country" FROM "gasstations" JOIN "transactions_1k" ON "gasstations"."GasStationID" = "transactions_1k"."GasStationID" WHERE "transactions_1k"."Date" = '2012-08-24' AND "transactions_1k"."Time" = '12:42:00'	debit_card_specializing
SELECT "ProductID" FROM "transactions_1k" WHERE "Date" = '2012-08-23' AND "Time" = '21:20:00'	debit_card_specializing
SELECT "Date", "Amount" FROM "transactions_1k" WHERE "CustomerID" = (SELECT "CustomerID" FROM "transactions_1k" WHERE "Date" = '2012-08-24' AND "Price" = 124.05) AND "Date" BETWEEN '2012-01-01' AND '2012-01-31';	debit_card_specializing
SELECT COUNT("TransactionID") FROM "transactions_1k" t JOIN "gasstations" g ON t."GasStationID" = g."GasStationID" WHERE g."Country" = 'CZE' AND t."Date" = '2012-08-26' AND t."Time" BETWEEN '08:00:00' AND '09:00:00';	debit_card_specializing
SELECT "Currency" FROM "customers" WHERE "CustomerID" = (SELECT "CustomerID" FROM "yearmonth" WHERE "Consumption" = 214582.17 AND "Date" LIKE '2013-06%')	debit_card_specializing
SELECT "Country" FROM "gasstations" JOIN "transactions_1k" ON "gasstations"."GasStationID" = "transactions_1k"."GasStationID" WHERE "transactions_1k"."CardID" = 667467	debit_card_specializing
SELECT "customers"."Country" FROM "transactions_1k" JOIN "customers" ON "transactions_1k"."CustomerID" = "customers"."CustomerID" WHERE "transactions_1k"."Amount" = 548 AND "transactions_1k"."Date" = '2012-08-24';	debit_card_specializing
SELECT COUNT(DISTINCT "CustomerID") * 100.0 / (SELECT COUNT(DISTINCT "CustomerID") FROM "transactions_1k" WHERE "Date" = '2012-08-25') AS "Percentage" FROM "customers" WHERE "Currency" = 'EUR' AND "CustomerID" IN (SELECT "CustomerID" FROM "transactions_1k" WHERE "Date" = '2012-08-25');	debit_card_specializing
SELECT y2012."Consumption" AS "Consumption_2012", y2013."Consumption" AS "Consumption_2013" FROM yearmonth AS y2012 JOIN transactions_1k AS t ON y2012."CustomerID" = t."CustomerID" JOIN yearmonth AS y2013 ON y2012."CustomerID" = y2013."CustomerID" WHERE t."Price" = 634.8 AND t."Date" = '2012-08-25' AND y2012."Date" LIKE '2012%' AND y2013."Date" LIKE '2013%';	debit_card_specializing
SELECT "gasstations"."GasStationID", SUM("transactions_1k"."Price") AS "TotalRevenue" FROM "gasstations" JOIN "transactions_1k" ON "gasstations"."GasStationID" = "transactions_1k"."GasStationID" GROUP BY "gasstations"."GasStationID" ORDER BY "TotalRevenue" DESC LIMIT 1	debit_card_specializing
SELECT (SUM(CASE WHEN "Segment" = 'premium' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS "Percentage" FROM "gasstations" JOIN "transactions_1k" ON "gasstations"."GasStationID" = "transactions_1k"."GasStationID" JOIN "customers" ON "transactions_1k"."CustomerID" = "customers"."CustomerID" WHERE "gasstations"."Country" = 'SVK';	debit_card_specializing
SELECT SUM("Amount") AS "TotalSpent" FROM "transactions_1k" WHERE "CustomerID" = 38508;	debit_card_specializing
SELECT "Description", SUM("Amount") AS "TotalSold" FROM "transactions_1k" JOIN "products" ON "transactions_1k"."ProductID" = "products"."ProductID" GROUP BY "Description" ORDER BY "TotalSold" DESC LIMIT 5	debit_card_specializing
SELECT "customers"."CustomerID", AVG("transactions_1k"."Price") AS "AveragePrice", "customers"."Currency" FROM "transactions_1k" JOIN "customers" ON "transactions_1k"."CustomerID" = "customers"."CustomerID" GROUP BY "customers"."CustomerID" ORDER BY SUM("transactions_1k"."Price" * "transactions_1k"."Amount") DESC LIMIT 1;	debit_card_specializing
SELECT "g"."Country" FROM "gasstations" AS "g" JOIN "transactions_1k" AS "t" ON "g"."GasStationID" = "t"."GasStationID" WHERE "t"."ProductID" = 2 ORDER BY "t"."Price" DESC LIMIT 1;	debit_card_specializing
SELECT "yearmonth"."CustomerID", "yearmonth"."Consumption" FROM "transactions_1k" JOIN "yearmonth" ON "transactions_1k"."CustomerID" = "yearmonth"."CustomerID" WHERE "transactions_1k"."ProductID" = 5 AND "transactions_1k"."Price" > 29.00 AND "yearmonth"."Date" = '2012-08-01';	debit_card_specializing
