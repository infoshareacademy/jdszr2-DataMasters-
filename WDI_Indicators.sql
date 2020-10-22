--- Ile wskaŸników charakteryzuje wybrane przez nas kraje:

with dane  as
(SELECT C.*, I.*, S.*
	FROM country C inner JOIN indicators I
		ON C.countrycode = I."CountryCode" 
		inner join series S
		on I."IndicatorName" = S.indicatorname 
			where C.countrycode like 'CHN' or C.countrycode like 'USA')
select CountryCode, Topic, IndicatorName, count("Year") from dane
group by CountryCode, Topic, IndicatorName
order by IndicatorName, CountryCode, count("Year")


--- Wybrany wskaŸnik dla danych krajów:

with dane  as
(SELECT C."countrycode" , I."IndicatorName",I."Value", I."Year", S.topic,  CN.description 
	FROM country C inner JOIN Indicators i
		ON C."countrycode" = I."CountryCode"
		inner join Series s
		on I."IndicatorName" = S."indicatorname"
		left join CountryNotes cn
		on C."countrycode" = CN."countrycode" and S."seriescode" = CN."seriescode" 
			where C."countrycode" like 'CHN' or C."countrycode" like 'USA')
select "countrycode", "Year", "Value", description from dane
where "IndicatorName" like 'Electricity production from renewable sources, excluding hydroelectric (kWh)'
order by "countrycode", "Year"



--- zamiana YR2000 na int: 2000

update footnotes set "Year" =  REPLACE ("Year" , 'yr', ''); 

update footnotes set "Year" =  REPLACE ("Year" , 'YR', '');

alter table footnotes alter column "Year" TYPE integer USING ("Year"::integer);


--- do³o¿enie footnotes i seriesnotes
with dane  as
(SELECT C."countrycode" , I."IndicatorName",I."Value", I."Year", S.topic,  CN.description as descripton_CN, FN.description as description_FN, FN."Year" as "Year_FN"
	FROM country C inner JOIN Indicators i
		ON C."countrycode" = I."CountryCode"
		inner join Series s
		on I."IndicatorName" = S."indicatorname"
		full outer join footnotes FN
		on C."countrycode" = FN."countrycode" and S."seriescode" = FN."seriescode" and I."Year"= FN."Year"
		left join CountryNotes cn
		on C."countrycode" = CN."countrycode" and S."seriescode" = CN."seriescode" 
			where C."countrycode" like 'CHN' or C."countrycode" like 'USA')
select "countrycode", "Year", "Value", "descripton_cn", "description_fn" from dane
where "IndicatorName" like 'Bank nonperforming loans to total gross loans (%)'
order by "countrycode", "Year"