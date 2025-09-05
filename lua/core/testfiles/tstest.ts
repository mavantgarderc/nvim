// simple typed map + async demo (Node or Deno)
type Person = { id: number; name: string; skills?: string[] };

const people: Person[] = [
  { id: 1, name: "Mava", skills: ["TS","Lua","Python"] },
  { id: 2, name: "Alex", skills: ["C#","SQL"] },
];

function findNames(sk: string) {
  return people.filter(p => p.skills?.includes(sk)).map(p => p.name);
}

(async function main() {
  console.log("Who knows TypeScript?", findNames("TS"));
  // fake async step
  await new Promise(res => setTimeout(res, 80));
  console.log("done");
})();
