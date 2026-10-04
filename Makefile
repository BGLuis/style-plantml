PLANTUML_VERSION ?= 1.2026.8
PLANTUML_JAR     ?= plantuml-$(PLANTUML_VERSION).jar
PLANTUML_SHA256  ?= 0f77e5f769836b3dee340e207fe497c3e4c43e973d559e3c306915da9c32e34c
MAVEN_URL        ?= https://repo1.maven.org/maven2/net/sourceforge/plantuml/plantuml/$(PLANTUML_VERSION)/$(PLANTUML_JAR)

PLANTUML         ?= java -jar $(PLANTUML_JAR)
FLAGS             = -Dplantuml.include.path=. -DPLANTUML_LIMIT_SIZE=16384

.PHONY: all comparison examples clean check-dupes download-plantuml test test-option-b

all: comparison examples

download-plantuml: $(PLANTUML_JAR)

$(PLANTUML_JAR):
	curl -fsSL -o $(PLANTUML_JAR) $(MAVEN_URL)
	@echo "$(PLANTUML_SHA256)  $(PLANTUML_JAR)" | sha256sum --check --status || (rm -f $(PLANTUML_JAR) && echo "SHA256 verification failed for $(PLANTUML_JAR)" && exit 1)

comparison: $(PLANTUML_JAR)
	$(PLANTUML) $(FLAGS) comparison/architecture/unstyled.puml
	$(PLANTUML) $(FLAGS) comparison/architecture/styled.puml
	$(PLANTUML) $(FLAGS) comparison/database/unstyled.puml
	$(PLANTUML) $(FLAGS) comparison/database/styled.puml
	$(PLANTUML) $(FLAGS) comparison/sequence/unstyled.puml
	$(PLANTUML) $(FLAGS) comparison/sequence/styled.puml

examples: $(PLANTUML_JAR)
	$(PLANTUML) $(FLAGS) examples/arch-light-no-sprites.puml
	$(PLANTUML) $(FLAGS) examples/db-light-no-sprites.puml
	$(PLANTUML) $(FLAGS) examples/arch-light-with-sprites.puml
	$(PLANTUML) $(FLAGS) examples/db-light-with-sprites.puml

clean:
	rm -f comparison/*/*.png examples/*.png examples/*.svg

check-dupes:
	@find . -name '*.png' -not -path './.git/*' | xargs md5sum 2>/dev/null | \
	  cut -d' ' -f1 | sort | uniq -d | \
	  grep . && echo "DUPLICATES FOUND" && exit 1 || echo "No duplicate PNGs."

test: $(PLANTUML_JAR) test-option-b
	@echo "=== Testing arch-light-with-sprites ==="
	@$(PLANTUML) $(FLAGS) -tsvg examples/arch-light-with-sprites.puml
	@IMAGES=$$(grep -o '<image' examples/arch-light-with-sprites.svg | wc -l); \
	  if [ "$$IMAGES" -lt 13 ]; then echo "FAIL: expected at least 13 <image tags, got $$IMAGES"; exit 1; fi
	@! grep -qE "Please|cannot include|Error line" examples/arch-light-with-sprites.svg || (echo "FAIL: error banner found in arch-light-with-sprites.svg"; exit 1)
	@! grep -q "</b>" examples/arch-light-with-sprites.svg || (echo "FAIL: unescaped </b> found in arch-light-with-sprites.svg"; exit 1)
	@echo "=== Testing db-light-with-sprites ==="
	@$(PLANTUML) $(FLAGS) -tsvg examples/db-light-with-sprites.puml
	@IMAGES_DB=$$(grep -o '<image' examples/db-light-with-sprites.svg | wc -l); \
	  if [ "$$IMAGES_DB" -lt 12 ]; then echo "FAIL: expected at least 12 <image tags, got $$IMAGES_DB"; exit 1; fi
	@! grep -qE "Please|cannot include|Error line" examples/db-light-with-sprites.svg || (echo "FAIL: error banner found in db-light-with-sprites.svg"; exit 1)
	@! grep -q "</b>" examples/db-light-with-sprites.svg || (echo "FAIL: unescaped </b> found in db-light-with-sprites.svg"; exit 1)
	@echo "=== Testing regression checks (fa5_ and skinparam padding) ==="
	@! grep -rn "fa5_" themes/ || (echo "FAIL: deprecated fa5_ prefix found in themes"; exit 1)
	@! grep -rn "skinparam padding" themes/ || (echo "FAIL: deprecated skinparam padding found in themes"; exit 1)
	@echo "All diagram and regression tests passed."

test-option-b: $(PLANTUML_JAR)
	@echo "=== Testing Option B (remote GitHub URL include) ==="
	@TMP_DIR=$$(mktemp -d); \
	  REF="$${GITHUB_HEAD_SHA:-$${GITHUB_SHA:-$$(git rev-parse HEAD 2>/dev/null || echo main)}}"; \
	  REPO="$${GITHUB_HEAD_REPO:-$${GITHUB_REPOSITORY:-BGLuis/style-plantml}}"; \
	  printf '@startuml\n!define STYLE_PLANTML https://raw.githubusercontent.com/%s/%s\n!include STYLE_PLANTML/themes/light/architecture.puml\n\nSVC_ACTOR(user, "User")\nSVC_COMPUTE(api, "API Service")\nuser --> api\n@enduml\n' "$$REPO" "$$REF" > "$$TMP_DIR/test.puml"; \
	  java -jar $(CURDIR)/$(PLANTUML_JAR) -tsvg "$$TMP_DIR/test.puml"; \
	  STATUS=$$?; \
	  if [ $$STATUS -ne 0 ]; then rm -rf "$$TMP_DIR"; echo "FAIL: Option B render returned exit code $$STATUS"; exit 1; fi; \
	  if grep -qE "Please|cannot include|Error line|Cannot open URL" "$$TMP_DIR/test.svg"; then rm -rf "$$TMP_DIR"; echo "FAIL: Option B SVG contains error"; exit 1; fi; \
	  IMG_COUNT=$$(grep -o '<image' "$$TMP_DIR/test.svg" | wc -l); \
	  if [ "$$IMG_COUNT" -lt 2 ]; then rm -rf "$$TMP_DIR"; echo "FAIL: Option B SVG missing icons"; exit 1; fi; \
	  rm -rf "$$TMP_DIR"; \
	  echo "Option B test passed successfully."
