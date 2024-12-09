import { readFileSync } from "fs";

type Rule = [string, string];
type Update = string[];

const solution = processInput(`${__dirname}/input.txt`);
console.log("Secret number:", solution);

function readLines(inputFilePath: string): string[] {
    const input = readFileSync(inputFilePath, 'utf-8');
    return input.replace(/\r\n/g, '\n').split('\n');
}

function processInput(inputFilePath: string): number {
    const { rules, updates } = parseInput(readLines(inputFilePath));
    const incorrectUpdates = updates.filter(update => !isUpdateCorrect(update, rules));

    const correctedUpdates = incorrectUpdates.map(update =>
        correctUpdate(update, rules)
    );

    return sumMiddleElements(correctedUpdates);
}

function parseInput(inputLines: string[]): { rules: Rule[], updates: Update[] } {
    return inputLines.reduce(
        (acc, line) => {
            if (line.includes('|')) {
                acc.rules.push(line.split('|') as Rule);
            } else if (line.includes(',')) {
                acc.updates.push(line.split(',') as Update);
            }
            return acc;
        },
        { rules: [], updates: [] }
    );
}

function isUpdateCorrect(update: Update, rules: Rule[]): boolean {
    return rules.every(rule => isRuleSatisfied(update, rule));
}

function isRuleSatisfied(update: Update, [firstPage, secondPage]: Rule): boolean {
    const firstPageIdx = update.indexOf(firstPage);
    const secondPageIdx = update.indexOf(secondPage);

    // If either page is missing, we can assume the rule is satisfied.
    if (firstPageIdx === -1 || secondPageIdx === -1) {
        return true;
    }

    return firstPageIdx < secondPageIdx;
}

function getMiddle<T>(array: T[]): T {
    return array[Math.floor(array.length / 2)];
}

function sumMiddleElements(updates: Update[]): number {
    return updates.reduce((sum, update) => sum + parseInt(getMiddle(update), 10), 0);
}

function correctUpdate(update: Update, rules: Rule[]): Update {
    let isCorrect = false;

    while (!isCorrect) {
        isCorrect = true;

        for (let i = 0; i < rules.length; i++) {
            const [firstPage, secondPage] = rules[i];
            const firstPageIdx = update.indexOf(firstPage);
            const secondPageIdx = update.indexOf(secondPage);

            if (firstPageIdx === -1 || secondPageIdx === -1) {
                continue;
            }

            if (firstPageIdx < secondPageIdx) {
                continue;
            }

            // If the pages are out of order, swap them
            swapElements(update, firstPageIdx, secondPageIdx);
            isCorrect = false;
        }
    }

    return update;
}


function swapElements<T>(array: T[], idxA: number, idxB: number): void {
    [array[idxA], array[idxB]] = [array[idxB], array[idxA]];
}
