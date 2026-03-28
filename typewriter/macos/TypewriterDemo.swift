// ============================================================
// Typewriter/macOS — Component Gallery & Design Reference
// ============================================================
//
// This file is a design review artifact — not shipped code.
// Open in Xcode and use Canvas (Cmd+Option+Return) to see
// all components rendered side by side in Light and Dark Mode.
//
// To compile as a standalone app for review:
//
//   swiftc -parse-as-library \
//          -target arm64-apple-macos13.0 \
//          TypewriterStyle.swift TypewriterDemo.swift \
//          -o TypewriterDemo
//   ./TypewriterDemo
//
// ============================================================

import SwiftUI
import AppKit

// MARK: - Preview Entry (Xcode Canvas) ────────────────────────────────────────

#if DEBUG
struct TypewriterGallery_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TypewriterGallery()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")

            TypewriterGallery()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
#endif

// MARK: - Gallery ─────────────────────────────────────────────────────────────

struct TypewriterGallery: View {
    @State private var inputText = ""
    @State private var toggle = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // ── Banner ───────────────────────────────────────────────
                VStack(alignment: .leading, spacing: 4) {
                    Text("TYPEWRITER / macOS")
                        .font(.twTitle)
                        .foregroundColor(.twInk)
                    Text("Design System — Component Gallery")
                        .font(.twSmall)
                        .foregroundColor(.twMuted)
                }
                .padding(TWSpacing.xxl)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.twZebra)
                .overlay(alignment: .bottom) { TWDivider() }

                VStack(alignment: .leading, spacing: TWSpacing.xxl) {

                    // ── Typography ───────────────────────────────────────
                    section("Typography") {
                        VStack(alignment: .leading, spacing: TWSpacing.lg) {
                            Text("Title (20 bold)")
                                .font(.twTitle).foregroundColor(.twInk)
                            Text("Heading (13 semibold)")
                                .font(.twHeading).foregroundColor(.twInk)
                            Text("Body copy (12 regular)")
                                .font(.twBody).foregroundColor(.twInk)
                            Text("Small metadata (10 regular)")
                                .font(.twSmall).foregroundColor(.twMuted)
                            Text("TINY LABEL (9 bold)")
                                .font(.twTiny).foregroundColor(.twMuted)
                            Text("code output / monospaced (11)")
                                .font(.twCode).foregroundColor(.twInk)
                        }
                    }

                    // ── Color Swatches ───────────────────────────────────
                    section("Color Tokens") {
                        HStack(spacing: TWSpacing.md) {
                            swatch("twInk",   .twInk)
                            swatch("twMuted", .twMuted)
                            swatch("twDim",   .twDim)
                            swatch("twRule",  .twRule)
                            swatch("twLive",  .twLive)
                            swatch("twWarn",  .twWarn)
                            swatch("twError", .twError)
                        }
                    }

                    // ── Buttons ──────────────────────────────────────────
                    section("Buttons") {
                        HStack(spacing: TWSpacing.lg) {
                            Button("primary") {}
                                .twButton()

                            Button("disabled") {}
                                .twButton()
                                .disabled(true)

                            Button("extract") {}
                                .twButton()

                            // Danger variant — override button style manually
                            Button("delete") {}
                                .buttonStyle(TWButtonStyle())
                                .foregroundColor(.twError)
                        }
                    }

                    // ── Tags / Badges ────────────────────────────────────
                    section("Tags & Badges") {
                        HStack(spacing: TWSpacing.lg) {
                            Text("[C]").twTag()
                            Text("[X]").twTag(color: .twMuted)
                            Text("● live").twTag(color: .twLive)
                            Text("12 turns").twTag(color: .twMuted)
                            Text("error").twTag(color: .twError)
                            Text("warning").twTag(color: .twWarn)
                        }
                    }

                    // ── Card ─────────────────────────────────────────────
                    section("Card") {
                        VStack(alignment: .leading, spacing: TWSpacing.sm) {
                            Text("session: quirky-wombat-jones")
                                .font(.twHeading)
                                .foregroundColor(.twInk)
                            Text("project: auto  ·  14 turns  ·  7 commands  ·  3 writes")
                                .font(.twSmall)
                                .foregroundColor(.twMuted)
                        }
                        .twCard(padding: TWSpacing.lg)
                    }

                    // ── Input ────────────────────────────────────────────
                    section("Input") {
                        TWTextField("search sessions...", text: $inputText)
                            .frame(maxWidth: 320)
                    }

                    // ── List Rows ─────────────────────────────────────────
                    section("List Rows") {
                        VStack(spacing: 0) {
                            ForEach(sampleRows, id: \.id) { row in
                                HStack(spacing: 0) {
                                    Text("[\(row.src)]")
                                        .font(.tw(9, weight: .bold))
                                        .foregroundColor(row.recent ? .twLive : .twMuted)
                                        .frame(width: 22, alignment: .leading)

                                    Text(row.slug)
                                        .font(.twSmall)
                                        .foregroundColor(.twInk)
                                        .frame(width: 160, alignment: .leading)

                                    Text(row.project)
                                        .font(.tw(10, weight: row.recent ? .semibold : .regular))
                                        .foregroundColor(.twInk)
                                        .lineLimit(1)

                                    Spacer()

                                    Text(row.ago)
                                        .font(.twTiny)
                                        .foregroundColor(row.recent ? .twLive : .twMuted)
                                }
                                .padding(.horizontal, TWSpacing.lg)
                                .padding(.vertical, TWSpacing.sm)
                                .twRow(highlighted: row.recent)
                            }
                        }
                        .overlay(Rectangle().stroke(Color.twRule, lineWidth: 1))
                    }

                    // ── Code Block ────────────────────────────────────────
                    section("Code Block") {
                        TWCodeBlock("""
                        $ go run ./extractor/main.go
                        [auto] scanning 612 session files...
                        [auto] 3 new sessions found
                        [auto] extraction complete in 1.2s
                        """)
                    }

                    // ── Section Header ─────────────────────────────────────
                    section("Section Header") {
                        VStack(spacing: 0) {
                            TWSectionHeader("Live Sessions")
                            Text("No live sessions")
                                .font(.twSmall)
                                .foregroundColor(.twMuted)
                                .padding(.vertical, TWSpacing.sm)
                        }
                    }

                }
                .padding(TWSpacing.xxl)
            }
        }
        .background(Color.twPaper)
        .frame(width: 640)
    }

    // ── Helpers ───────────────────────────────────────────────────────────

    @ViewBuilder
    private func section<C: View>(_ title: String, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: TWSpacing.lg) {
            TWSectionHeader(title)
            content()
        }
    }

    @ViewBuilder
    private func swatch(_ label: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Rectangle()
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(Rectangle().stroke(Color.twRule, lineWidth: 1))
            Text(label)
                .font(.twTiny)
                .foregroundColor(.twMuted)
        }
    }
}

// MARK: - Sample Data ──────────────────────────────────────────────────────────

private struct SampleRow {
    let id: Int
    let src: String
    let slug: String
    let project: String
    let ago: String
    let recent: Bool
}

private let sampleRows: [SampleRow] = [
    SampleRow(id: 1, src: "C", slug: "quirky-wombat-jones",  project: "auto",          ago: "2s",  recent: true),
    SampleRow(id: 2, src: "C", slug: "joyful-puzzling-clark", project: "projects",      ago: "4m",  recent: false),
    SampleRow(id: 3, src: "X", slug: "8f2c91bb",              project: "agent-island",  ago: "12m", recent: false),
    SampleRow(id: 4, src: "C", slug: "brave-elegant-newton",  project: "bandwidther",   ago: "1h",  recent: false),
    SampleRow(id: 5, src: "C", slug: "stoic-bright-morse",    project: "auto",          ago: "3h",  recent: false),
]

// MARK: - Standalone Entry Point ───────────────────────────────────────────────

@main
struct TypewriterDemoApp: App {
    var body: some Scene {
        WindowGroup("Typewriter/macOS — Gallery") {
            TypewriterGallery()
        }
        .windowResizability(.contentSize)
    }
}
