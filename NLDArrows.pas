unit NLDArrows;

interface

uses
  Classes, Controls, Graphics;

type
  TArrowPos = (apLeft, apTopLeft, apTop, apTopRight, apRight, apBottomRight,
    apBottom, apBottomLeft);
  TArrows = set of TArrowPos;

  TNLDArrow = class(TCustomControl)
  private
    FArrows: TArrows;
    FArrowSize: Integer;
    FLineWidth: Integer;
    FArrowColor: TColor;
    procedure SetArrows(const Value: TArrows);
    procedure SetArrowSize(const Value: Integer);
    procedure SetLineWidth(const Value: Integer);
    procedure SetArrowColor(const Value: TColor);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ArrowColor: TColor read FArrowColor write SetArrowColor
      default clBlack;
    property Arrows: TArrows read FArrows write SetArrows
      default [apLeft, apRight];
    property ArrowSize: Integer read FArrowSize write SetArrowSize default 10;
    property LineWidth: Integer read FLineWidth write SetLineWidth default 2;
  end;

procedure Register;

implementation

uses
  Math;

procedure Register;
begin
  RegisterComponents('NLDelphi', [TNLDArrow]);
end;

{ TNLDArrow }

constructor TNLDArrow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FArrows := [apLeft, apRight];
  FArrowSize := 10;
  SetLineWidth(2);
end;

procedure TNLDArrow.Paint;

  procedure PaintArrow(const X, Y: Integer);
  var
    A: Extended;
    B: Extended;
    L: Integer;
  begin
    L := FArrowSize;
    Canvas.MoveTo(X, Y);
    Canvas.LineTo(Width div 2, Height div 2);
    Canvas.MoveTo(X, Y);
    if X <> Width div 2 then
      A := ArcTan((Y - Height div 2) / (X - Width div 2))
    else if Y = 0 then
      A := DegToRad(90)
    else
      A := DegToRad(270);
    if X = Width then
      A := A - DegToRad(180);
    B := A - DegToRad(20);
    Canvas.LineTo(X + Trunc(Cos(B) * L), Y + Trunc(Sin(B) * L));
    Canvas.MoveTo(X, Y);
    B := A + DegToRad(20);
    Canvas.LineTo(X + Trunc(Cos(B) * L), Y + Trunc(Sin(B) * L));
  end;

begin
  Canvas.Pen.Color := FArrowColor;
  if apLeft in FArrows then
    PaintArrow(0, Height div 2);
  if apTopLeft in FArrows then
    PaintArrow(0, 0);
  if apTop in FArrows then
    PaintArrow(Width div 2, 0);
  if apTopRight in FArrows then
    PaintArrow(Width, 0);
  if apRight in FArrows then
    PaintArrow(Width, Height div 2);
  if apBottomRight in FArrows then
    PaintArrow(Width, Height);
  if apBottom in FArrows then
    PaintArrow(Width div 2, Height);
  if apBottomLeft in FArrows then
    PaintArrow(0, Height);
end;

procedure TNLDArrow.SetArrowColor(const Value: TColor);
begin
  if FArrowColor <> Value then
  begin
    FArrowColor := Value;
    Invalidate;
  end;
end;

procedure TNLDArrow.SetArrows(const Value: TArrows);
begin
  if FArrows <> Value then
  begin
    FArrows := Value;
    Invalidate;
  end;
end;

procedure TNLDArrow.SetArrowSize(const Value: Integer);
begin
  if FArrowSize <> Value then
  begin
    FArrowSize := Value;
    Invalidate;
  end;
end;

procedure TNLDArrow.SetLineWidth(const Value: Integer);
begin
  if FLineWidth <> Value then
  begin
    Canvas.Pen.Width := Value;
    FLineWidth := Canvas.Pen.Width;
    Invalidate;
  end;
end;

end.
