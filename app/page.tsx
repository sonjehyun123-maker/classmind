import { createClient } from "@/lib/supabase/server";

export default async function Home() {
  const supabase = await createClient();

  const { error } = await supabase.auth.getSession();

  return (
    <main style={{ padding: "2rem" }}>
      <h1>StudyNote</h1>
      <p>Supabase 연결 테스트</p>
      <p>{error ? "연결 실패" : "연결 성공"}</p>
    </main>
  );
}