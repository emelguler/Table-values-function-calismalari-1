use Okul


--amacý nedir? bir öðrencinin ilgili dersteki siralamasini veren fonksiyon:

CREATE FUNCTION [dbo].[FN$OgrencininIlgiliDerstekiSiralamasi] 
(
  @Ogrenci_Id int,
  @Ders_Id int
)
RETURNS tinyint
AS 
    BEGIN
	return (
	          select a.Sira from (
	                           select o.Id as Ogrenci_Id,
	          		                  o.Adi+' '+o.SoyAdi as AdiSoyadi,
                                      d.Id as Ders_Id,
                                      d.Adi as DersAdi,
	                                  ood.Vize,
	                                  ood.Final,
	                                  (ood.Vize*0.4+ood.Final*0.6) as Ortalama,
	                                  ROW_NUMBER() OVER (ORDER BY (ood.Vize*0.4+ood.Final*0.6) desc) AS Sira
                               from dbo.OgrenciOgretmenDers as ood
                               inner join dbo.Ogrenci as o on o.Id = ood.Ogrenci_Id and o.Statu = 1
                               inner join dbo.OgretmenDers as od on od.Id = ood.OgretmenDers_Id and od.Statu = 1
                               inner join dbo.Ders as d on d.Id = od.Ders_Id and d.Statu = 1
                               where  ood.Statu =1
                               and od.Ders_Id = @Ders_Id
                          ) as a
               where a.Ogrenci_Id = @Ogrenci_Id
	)

    END







--where clause kontrolü:

--declare @Ogrenci_Id int = 3,
--        @Ders_Id int = 8
--
--select * from (
--	          select o.Id as Ogrenci_Id,
--			         o.Adi+' '+o.SoyAdi as AdiSoyadi,
--                     d.Id as Ders_Id,
--                     d.Adi as DersAdi,
--	                 ood.Vize,
--	                 ood.Final,
--	                 (ood.Vize*0.4+ood.Final*0.6) as Ortalama,
--	                 ROW_NUMBER() OVER (ORDER BY (ood.Vize*0.4+ood.Final*0.6) desc) AS Sira
--              from dbo.OgrenciOgretmenDers as ood
--              inner join dbo.Ogrenci as o on o.Id = ood.Ogrenci_Id and o.Statu = 1
--              inner join dbo.OgretmenDers as od on od.Id = ood.OgretmenDers_Id and od.Statu = 1
--              inner join dbo.Ders as d on d.Id = od.Ders_Id and d.Statu = 1
--              where  ood.Statu =1
--              and od.Ders_Id = @Ders_Id
--) as a
--where a.Ogrenci_Id = @Ogrenci_Id



--cagiralim.
select [dbo].[FN$OgrencininIlgiliDerstekiSiralamasi](3,8)