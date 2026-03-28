// ============================================================
// Typewriter/macOS — SwiftUI Design System
// ============================================================
//
// The typewriter aesthetic ported to native SwiftUI/macOS:
//
//   Web original       → macOS equivalent
//   ─────────────────────────────────────────────────
//   Courier Prime      → SF Mono (system native)
//   #111 ink           → NSColor.labelColor (dark-mode aware)
//   #fff paper         → NSColor.windowBackgroundColor
//   1px solid border   → Rectangle().stroke(..., lineWidth: 1)
//   border-radius: 0   → (implicit — no .cornerRadius())
//   repeating gradient → subtle .background(Color.twZebra)
//
// USAGE:
//   import SwiftUI
//   // Copy this file into your project — no package needed.
//
//   Text("hello").font(.tw(13))
//   VStack { ... }.twCard()
//   Button("submit") { }.twButton()
//
// ============================================================

import SwiftUI
import AppKit

// MARK: - Color Tokens ─────────────────────────────────────────────────────
//
// All colors use semantic NSColor values so they automatically
// invert in Dark Mode — matching the web version's light-only
// palette but without requiring a light-mode lock.

public extension Color {

    // ── Core palette ────────────────────────────────────────────────────

    /// Primary text color. Equivalent to CSS --tw-ink (#111).
    static let twInk     = Color(nsColor: .labelColor)

    /// Window/page background. Equivalent to CSS --tw-paper (#fff).
    static let twPaper   = Color(nsColor: .windowBackgroundColor)

    /// Secondary / muted text. Equivalent to CSS --tw-muted (#555).
    static let twMuted   = Color(nsColor: .secondaryLabelColor)

    /// Tertiary label — for very dim metadata.
    static let twDim     = Color(nsColor: .tertiaryLabelColor)

    /// Rule lines and borders. Equivalent to CSS --tw-rule (#d0d0d0).
    static let twRule    = Color(nsColor: .separatorColor)

    /// Subtle row / card background tint (replaces hover state in lists).
    static let twZebra   = Color.primary.opacity(0.025)

    /// Slightly stronger tint for selected / active states.
    static let twActive  = Color.primary.opacity(0.06)

    // ── Semantic accents ─────────────────────────────────────────────────

    /// "Live" / success state — typewriter green.
    static let twLive    = Color(red: 0.18, green: 0.68, blue: 0.28)

    /// Warning / attention.
    static let twWarn    = Color(red: 0.75, green: 0.50, blue: 0.05)

    /// Error / destructive. Equivalent to CSS --tw-error (#7a0000).
    static let twError   = Color(red: 0.65, green: 0.05, blue: 0.05)
}

// MARK: - Typography Tokens ───────────────────────────────────────────────────
//
// SF Mono is the macOS native monospace — it mirrors the weight
// and optical characteristics of Courier Prime without needing
// a web font load.

public extension Font {

    /// Standard monospaced font at the given size and weight.
    /// Use this everywhere — keep the codebase monotype-homogeneous.
    static func tw(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }

    // ── Semantic aliases ─────────────────────────────────────────────────

    /// Large title — banner / app name level.
    static let twTitle    = tw(20, weight: .bold)

    /// Section heading.
    static let twHeading  = tw(13, weight: .semibold)

    /// Normal body copy.
    static let twBody     = tw(12)

    /// Small metadata / labels.
    static let twSmall    = tw(10)

    /// Tiny — column headers, badges.
    static let twTiny     = tw(9, weight: .bold)

    /// Monospaced code / output text.
    static let twCode     = tw(11)
}

// MARK: - Spacing Tokens ──────────────────────────────────────────────────────

public enum TWSpacing {
    public static let xs:  CGFloat =  4   // --tw-gap-xs
    public static let sm:  CGFloat =  6   // --tw-gap-sm
    public static let md:  CGFloat =  8   // --tw-gap-md
    public static let lg:  CGFloat = 12   // --tw-gap-xl
    public static let xl:  CGFloat = 16   // medium padding
    public static let xxl: CGFloat = 24   // --tw-pad-lg
}

// MARK: - View Modifiers ──────────────────────────────────────────────────────
//
// Modifiers compose the tokens into reusable UI patterns.
// Each modifier is intentionally minimal — they add structure
// without adding decoration.

// ── Card ─────────────────────────────────────────────────────────────────────
//
// A 1px bordered container. Direct equivalent of the web's
// button/input box model: visible boundary, no rounding.

public struct TWCardModifier: ViewModifier {
    var padding: CGFloat

    public func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.twPaper)
            .overlay(Rectangle().stroke(Color.twRule, lineWidth: 1))
    }
}

public extension View {
    /// Wrap content in a typewriter-style 1px bordered card.
    func twCard(padding: CGFloat = TWSpacing.md) -> some View {
        modifier(TWCardModifier(padding: padding))
    }
}

// ── Button ────────────────────────────────────────────────────────────────────
//
// Ink-bordered button with plain hover/active states.
// Matches the web `.button` component behavior.

public struct TWButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.twBody)
            .foregroundColor(isEnabled ? .twInk : .twMuted)
            .padding(.horizontal, TWSpacing.md)
            .padding(.vertical, TWSpacing.sm - 1)
            .background(configuration.isPressed ? Color.twActive : Color.twPaper)
            .overlay(
                Rectangle().stroke(
                    isEnabled ? Color.twInk : Color.twRule,
                    lineWidth: 1
                )
            )
            .opacity(isEnabled ? 1.0 : 0.6)
    }
}

public extension View {
    /// Apply the typewriter button style.
    func twButton() -> some View {
        self.buttonStyle(TWButtonStyle())
    }
}

// ── Row ───────────────────────────────────────────────────────────────────────
//
// Adds a bottom rule line — for list rows and table cells.
// Matches the CSS `border-bottom: 1px solid var(--tw-rule)` pattern.

public struct TWRowModifier: ViewModifier {
    var highlighted: Bool

    public func body(content: Content) -> some View {
        content
            .background(highlighted ? Color.twActive : Color.clear)
            .overlay(alignment: .bottom) {
                Color.twRule.frame(height: 1).opacity(0.5)
            }
    }
}

public extension View {
    /// Add a bottom ruled line (list-row separator).
    func twRow(highlighted: Bool = false) -> some View {
        modifier(TWRowModifier(highlighted: highlighted))
    }
}

// ── Tag / Badge ───────────────────────────────────────────────────────────────
//
// A tight monospaced label with an optional color tint.
// Matches the web's small bordered chip pattern.

public struct TWTagModifier: ViewModifier {
    var color: Color

    public func body(content: Content) -> some View {
        content
            .font(.twTiny)
            .foregroundColor(color)
            .padding(.horizontal, TWSpacing.sm)
            .padding(.vertical, TWSpacing.xs - 1)
            .overlay(Rectangle().stroke(color.opacity(0.4), lineWidth: 1))
    }
}

public extension View {
    /// Style as a typewriter badge/tag.
    func twTag(color: Color = .twInk) -> some View {
        modifier(TWTagModifier(color: color))
    }
}

// ── Section Header ────────────────────────────────────────────────────────────
//
// Uppercase small heading with a bottom rule.
// Equivalent to a `<h3>` in the typewriter CSS.

public struct TWSectionHeader: View {
    let title: String

    public init(_ title: String) { self.title = title }

    public var body: some View {
        VStack(spacing: 0) {
            Text(title.uppercased())
                .font(.twTiny)
                .foregroundColor(.twMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, TWSpacing.sm)
            Color.twRule.frame(height: 1)
        }
    }
}

// ── Ruled Divider ─────────────────────────────────────────────────────────────

public struct TWDivider: View {
    public init() {}
    public var body: some View {
        Color.twRule.frame(height: 1)
    }
}

// ── Input Field ───────────────────────────────────────────────────────────────
//
// Styled text field. 1px ink border, monospace, no rounding.

public struct TWTextField: View {
    let placeholder: String
    @Binding var text: String

    public init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    public var body: some View {
        TextField(placeholder, text: $text)
            .font(.twBody)
            .foregroundColor(.twInk)
            .textFieldStyle(.plain)
            .padding(.horizontal, TWSpacing.md)
            .padding(.vertical, TWSpacing.sm)
            .overlay(Rectangle().stroke(Color.twInk, lineWidth: 1))
    }
}

// ── Code Block ────────────────────────────────────────────────────────────────

public struct TWCodeBlock: View {
    let text: String

    public init(_ text: String) { self.text = text }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(text)
                .font(.twCode)
                .foregroundColor(.twInk)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(TWSpacing.md)
                .textSelection(.enabled)
        }
        .background(Color.twZebra)
        .overlay(Rectangle().stroke(Color.twRule, lineWidth: 1))
    }
}
