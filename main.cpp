#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>

#include "collisionengine.h"
#include "utils.h"
#include "nodestyle.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setOrganizationName("Bepa");
    QGuiApplication::setApplicationName("Idea");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setApplicationVersion("1");

    QFont font;
    font.setFamily(("Microsoft YaHei"));
    font.setPointSize(12);
    app.setFont(font);

    QTranslator translator;
    translator.load("bepaidea_zh_CN");
    app.installTranslator(&translator);

    qmlRegisterType<NodeStyle>("BepaIdea", 1, 0, "NodeStyle");

    QQmlApplicationEngine engine;

    QQmlContext *context = engine.rootContext();
    CollisionEngine collisionEngine;
    context->setContextProperty("Engine", &collisionEngine);
    Utils utils;
    context->setContextProperty("Utils", &utils);
    context->setContextProperty("App", &app);

    engine.load(QUrl(QStringLiteral("qrc:/MainWindow.qml")));

    return app.exec();
}
