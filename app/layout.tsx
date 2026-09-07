import "./globals.css";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "StudyNote",
  description: "AI 수업 비서",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="ko">
      <body>{children}</body>
    </html>
  );
}
