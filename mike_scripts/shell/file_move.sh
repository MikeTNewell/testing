echo $1
 for ff in `ls *.sql`
        do 
        echo $ff
        diff $ff $1/sql/$ff
        echo "$ff ---   $1"
        echo "Press Y to move \c"
        read res
if [ "$res" = "Y" ]
then
          cp $1/sql/$ff $1/sql/$ff.20041119
          cp $ff $1/sql
         echo "file $ff moved."
fi
done

