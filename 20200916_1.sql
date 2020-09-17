
SELECT a.sido, a.sigungu, a.cnt, b.cnt, ROUND(a.cnt/b.cnt, 2) di
FROM
    (SELECT sido, sigungu, COUNT(*) cnt
    FROM fastfood
    WHERE gb IN('KFC', '맥도날드', '버거킹')
    GROUP BY sido, sigungu) a,
    (SELECT sido, sigungu, COUNT(*) cnt
    FROM fastfood
    WHERE gb = '롯데리아'
    GROUP BY sido, sigungu ) b
WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
ORDER BY di DESC;



-----------------------------------------------------
kfc 건수, 롯데리아 건수, 버거킹 건수, 맥도날드 건수

SELECT sido, sigungu, 
        ROUND((NVL(SUM(DECODE(gb, 'KFC', cnt)), 0) +       
        NVL(SUM(DECODE(gb, '버거킹', cnt)), 0) +
        NVL(SUM(DECODE(gb, '맥도날드', cnt)), 0) ) /        
        NVL(SUM(DECODE(gb, '롯데리아', cnt)), 1), 2) di 
FROM 
(SELECT sido, sigungu, gb, COUNT(*) cnt
 FROM fastfood
 WHERE gb IN ('KFC', '롯데리아', '버거킹', '맥도날드')
 GROUP BY sido, sigungu, gb)
GROUP BY sido, sigungu 
ORDER BY di DESC;

--------------------------------------------------------
SELECT b.sido, b.sigungu, b.p_sal, d.*
FROM
    (SELECT ROWNUM rank, a.*
    FROM (SELECT sido, sigungu, ROUND(sal/people) p_sal
            FROM tax
            ORDER BY p_sal DESC)a)b , 

    (SELECT ROWNUM rank, c.*
    FROM    (SELECT sido, sigungu, 
            ROUND((NVL(SUM(DECODE(gb, 'KFC', cnt)), 0) +       
            NVL(SUM(DECODE(gb, '버거킹', cnt)), 0) +
            NVL(SUM(DECODE(gb, '맥도날드', cnt)), 0) ) /        
            NVL(SUM(DECODE(gb, '롯데리아', cnt)), 1), 2) di 
        FROM 
        (SELECT sido, sigungu, gb, COUNT(*) cnt
        FROM fastfood
        WHERE gb IN ('KFC', '롯데리아', '버거킹', '맥도날드')
        GROUP BY sido, sigungu, gb)
        GROUP BY sido, sigungu 
        ORDER BY di DESC)c)d
WHERE b.rank = d.rank;

도시발전지수 1 - 세금 1위