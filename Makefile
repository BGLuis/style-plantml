PLANTUML = java -jar plantuml.jar
FLAGS    = -Dplantuml.include.path=. -DPLANTUML_LIMIT_SIZE=16384

.PHONY: all comparison examples clean check-dupes

all: comparison examples

comparison:
	$(PLANTUML) $(FLAGS) comparison/architecture/unstyled.puml
	$(PLANTUML) $(FLAGS) comparison/architecture/styled.puml
	$(PLANTUML) $(FLAGS) comparison/database/unstyled.puml
	$(PLANTUML) $(FLAGS) comparison/database/styled.puml
	$(PLANTUML) $(FLAGS) comparison/sequence/unstyled.puml
	$(PLANTUML) $(FLAGS) comparison/sequence/styled.puml

examples:
	$(PLANTUML) $(FLAGS) examples/arch-light-no-sprites.puml
	$(PLANTUML) $(FLAGS) examples/db-light-no-sprites.puml
	$(PLANTUML) $(FLAGS) examples/arch-light-with-sprites.puml
	$(PLANTUML) $(FLAGS) examples/db-light-with-sprites.puml

clean:
	rm -f comparison/*/*.png examples/*.png

check-dupes:
	@find . -name '*.png' -not -path './.git/*' | xargs md5sum 2>/dev/null | \
	  cut -d' ' -f1 | sort | uniq -d | \
	  grep . && echo "DUPLICATES FOUND" && exit 1 || echo "No duplicate PNGs."
