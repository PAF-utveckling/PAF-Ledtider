-- ==========================================================================
-- ==========================================================================
-- SQL fr�ga avsedd att skapa l�mpliga data f�r QlickView fr�n PAF databasen
-- Datum: 2016-05-16
-- Utvecklad av: Niklas Storck
-- epost: niklas.storck@capiostgoran.se; niklas@family-storck.se
-- Telefon: 0736-841 220
--
-- Revisioner:
-- Gren f�r DVT endast 2016-05-16
-- Justerad f�r QV
-- Bla har koppling till fysweb gjorts f�r att f� med tid f�r e-remiss.
-- 0.2.1 Prodtab tillagd
-- 0.2 �ndrad sortering 2015-05-07
-- 0.1 Grund, Niklas Storck 2015-05-04
--
-- ==========================================================================
-- ==========================================================================

use fyspaf
SELECT 
	   REMTAB.REMISSNR as Remissnummer, -- Vill jag ha med f�r sp�rbarheten till en enskild patient i PAF
	   -- Koll att join fungerar som det ska, f�r min f�rst�else, kan tas bort sen
	    -- PATTAB.REMISSNR, 
	   REMTAB.LEVT as leverant�r,
	   PRODTAB.PRODGRP as produktGrupp,
	   REMTAB.PRODKOD as Produktkod,

	   PRODTAB.KTXT as Produktbeskrivning,
	   -- **
	   REMTAB.MOTT as Kombika,
	   BESTTAB.NAMN as RemittentKlinik,
	   BESTTAB.KST  as kostnadsst�lle,


	   -- e-RemissDatum uppdelat p� �r m�nad etc.
	   PWRemissTab.best_datumtid as eRemissTid,
	   YEAR(PWRemissTab.best_datumtid) as eRem�r,
	   MONTH(PWRemissTab.best_datumtid) as eRemM�nad,
	   DAY(PWRemissTab.best_datumtid) as eRemDag, 
	   DATENAME(hour,PWRemissTab.best_datumtid) as eRemTimme,
	   DATENAME(MINUTE,PWRemissTab.best_datumtid) as eRemMinut,
	   DATENAME(weekday,PWRemissTab.best_datumtid) as eRemVeckodag,


	   PATTAB.REMGRANSKDATUMTID as Granskad,
	   pattab.bokaddatumtid as BokadTid,

	   -- RemissDatum uppdelat p� �r m�nad etc.
       PATTAB.REMDATUMTID as RemDatumTid,
	   YEAR(PATTAB.REMDATUMTID) as Rem�r,
	   MONTH(PATTAB.REMDATUMTID) as RemM�nad,
	   DAY(PATTAB.REMDATUMTID) as RemDag, 
	   DATENAME(hour,PATTAB.REMDATUMTID) as RemTimme,
	   DATENAME(MINUTE,PATTAB.REMDATUMTID) as RemMinut,
	   DATENAME(weekday,PATTAB.REMDATUMTID) as RemVeckodag,

	   -- Signeringsdatum uppdelat p� �r m�nad etc.
       PATTAB.SIGNDATUMTID as Signerad,
	   YEAR(PATTAB.SIGNDATUMTID) as Sign�r,
	   MONTH(PATTAB.SIGNDATUMTID) as SignM�nad,
	   DAY(PATTAB.SIGNDATUMTID) as SignDag, 
	   DATENAME(hour,PATTAB.SIGNDATUMTID) as SignTimme,
	   DATENAME(MINUTE,PATTAB.SIGNDATUMTID) as SignMinut,
	   DATENAME(weekday,PATTAB.SIGNDATUMTID) as SignVeckodag,


	   PATTAB.UNDSTARTDATUMTID as UsStart,

       PATTAB.UNDSLUTDATUMTID as USSlut,
	  
	  -- ******************************************************
	  --            Ber�knade variabler
	  -- ******************************************************
	   -- pattab.SIGNDATUMTID - PWRemissTab.best_datumtid as RemissToSign,
	   Day(pattab.SIGNDATUMTID - PWRemissTab.best_datumtid)-1 as Rem2SignDag,
	   DATENAME(hour,pattab.SIGNDATUMTID - PWRemissTab.best_datumtid) as Rem2SignTimme,
	   DATENAME(MINUTE,pattab.SIGNDATUMTID - PWRemissTab.best_datumtid) as Rem2SignMinut,
	  
	   -- pattab.SIGNDATUMTID - pattab.UNDSLUTDATUMTID    as UndslutToSign,  
	   Day(pattab.SIGNDATUMTID - pattab.UNDSLUTDATUMTID)-1 as UndslutToSignDag,
	   DATENAME(hour,pattab.SIGNDATUMTID - pattab.UNDSLUTDATUMTID) as UndslutToSignTimme,
	   DATENAME(MINUTE,pattab.SIGNDATUMTID - pattab.UNDSLUTDATUMTID) as UndslutToSignMinut,
	  
	   -- pattab.UNDSLUTDATUMTID  - pattab.UNDSTARTDATUMTID   as UndStartToUndSlut,  
	   Day(pattab.UNDSLUTDATUMTID  - pattab.UNDSTARTDATUMTID)-1 as UndStartToUndSlutDag,
	   DATENAME(hour,pattab.UNDSLUTDATUMTID  - pattab.UNDSTARTDATUMTID) as UndStartToUndSlutTimme,
	   DATENAME(MINUTE,pattab.UNDSLUTDATUMTID  - pattab.UNDSTARTDATUMTID) as UndStartToUndSlutMinut,
	  
	  -- ***************************************************** 
	  -- *****************************************************
	   
	   REMTAB.MASK as �nskadVikt,
       PATTAB.MODMASK as Vikt,
	   PATTAB.BESTLAK as Remittent,
       PATTAB.LABLAK as L�kare,
       PATTAB.LABASS as BMA,
	   PATTAB.SIGNLAK as Signerande,

	   PERSONTAB.BADRESS as Adress,
	   PERSONTAB.PADRESS as Postadress
	   
	   
-- Joinsatserna h�r beh�ver kollas och beror rimligen p� hur databasen �r uppbyggd.
-- Jag har lagt till Prodtab f�r att f� unders�kningstyperna i klartext /NS 2015-05-07
-- Koppla �ven fyweb
FROM ((((PATTAB right JOIN REMTAB ON  PATTAB.REMISSNR = REMTAB.REMISSNR) 
        left join PRODTAB on  REMTAB.PRODKOD = PRODTAB.PRODKOD) 
		left join Fysweb.dbo.PWRemissTab on  RemissNrLab = REMTAB.REMISSNR) 
		left join BESTTAB on BESTTAB.ID = REMTAB.BEST) 
		left join PERSONTAB on PATTAB.PNR = PERSONTAB.PNR


where pattab.SIGNDATUMTID >= '2016-01-01' 
-- and REMTAB.PRODKOD = '516'

FOR XML PATH;

