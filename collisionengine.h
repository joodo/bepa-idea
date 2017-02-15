#ifndef COLLISIONENGINE_H
#define COLLISIONENGINE_H

#include <QObject>
#include <QQuickItem>
#include <QTimer>
#include <QQueue>
#include <QList>

class CollisionEngine : public QObject
{
    Q_OBJECT
public:
    explicit CollisionEngine(QObject *parent = 0);

signals:

public slots:
    void setNodesContainer(QQuickItem* canvas);
    void itemsChanged(const QVariantList& changedItems);

private slots:
    void update();

private:
    QQuickItem* canvas;
    QQueue<QQuickItem *> waitToArrange;  // 等待排布的节点
    QTimer* timer;

    const static int STEP = 20;
    const static int MSEC = 10;
};

#endif // COLLISIONENGINE_H
